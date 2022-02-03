-- Interiors

TARDIS.Metadata={}
TARDIS.MetadataRaw={}

TARDIS:AddSetting({
	id="randomize_skins",
	name="Randomize TARDIS skins at spawn",
	value=true,
	type="bool",
	networked=true,
	option=true,
	desc="Whether or not TARDIS skin will be randomized when it's spawned"
})

TARDIS:AddSetting({
	id="use_classic_door_interiors",
	name="Use classic door interiors by default",
	value=true,
	type="bool",
	networked=true,
	option=true,
	section="Misc",
	desc="Whether classic (big) door versions of interiors will spawn by default"
})

function TARDIS:ShouldUseClassicDoors(ply)
	return TARDIS:GetSetting("use_classic_door_interiors", true, ply)
end

function TARDIS:SelectDoorVersionID(x, ply)
	local version = (istable(x) and x) or TARDIS:GetInterior(x).Versions.main
	if not version then return end

	if not version.classic_doors_id then return version.id end

	return (TARDIS:ShouldUseClassicDoors(ply) and version.classic_doors_id) or version.double_doors_id

end



----------------------------------------------------------------------------------------------------
-- Interior preferences (favorites and excluded from redecoration)

local empty_int_preferences = {
	favorites = {},
	unwanted = {},
}

TARDIS:AddSetting({
	id = "interior_preferences",
	name = "Interior preferences",
	value = empty_int_preferences,
	option = false,
	networked = true
})

function TARDIS:GetIntPreferences(ply)
	return TARDIS:GetSetting("interior_preferences", empty_int_preferences, ply)
end

function TARDIS:SaveIntPreferences(preferences)
	TARDIS:SetSetting("interior_preferences", preferences, true)
end

function TARDIS:IsFavoriteInt(id, ply)
	return TARDIS:GetIntPreferences(ply).favorites[id]
end

function TARDIS:IsUnwantedInt(id, ply)
	return TARDIS:GetIntPreferences(ply).unwanted[id]
end

function TARDIS:SetFavoriteInt(id, favorite, ply)
	if favorite == false then favorite = nil end -- clean up (mainly for debugging purposes)

	local interior_preferences = TARDIS:GetIntPreferences(ply)
	interior_preferences.favorites[id] = favorite
	self:SaveIntPreferences(interior_preferences)
end

function TARDIS:SetUnwantedInt(id, unwanted, ply)
	if unwanted == false then unwanted = nil end -- clean up (mainly for debugging purposes)

	local interior_preferences = TARDIS:GetIntPreferences(ply)
	interior_preferences.unwanted[id] = unwanted
	self:SaveIntPreferences(interior_preferences)
end

function TARDIS:ToggleFavoriteInt(id, ply)
	TARDIS:SetFavoriteInt(id, not TARDIS:IsFavoriteInt(id, ply), ply)
end

function TARDIS:ToggleUnwantedInt(id, ply, sync_id)
	value = not TARDIS:IsUnwantedInt(id, ply)
	TARDIS:SetUnwantedInt(id, value, ply)
	if sync_id then TARDIS:SetUnwantedInt(sync_id, value, ply) end
end

function TARDIS:SelectNewRandomInterior(current, ply)
	local chosen_int
	local attempts = 300

	while not chosen_int or chosen_int == current
		or TARDIS.Metadata[chosen_int].Base == true
		or TARDIS:IsUnwantedInt(chosen_int, ply)
	do
		chosen_int = table.Random(TARDIS.Metadata).ID
		attempts = attempts - 1
		if attempts < 1 then
			return "default"
		end
	end

	if chosen_int.IsVersionOf then
		chosen_int = chosen_int.IsVersionOf
	end
	chosen_int = TARDIS:SelectDoorVersionID(chosen_int, ply)

	return chosen_int
end



----------------------------------------------------------------------------------------------------
-- Adding interiors, interior versions and overrides

local function create_merge_table(base, t)
	local copy=table.Copy(base)
	table.Merge(copy,t)
	return copy
end

local function merge_interior(base,t)
	return create_merge_table(TARDIS.Metadata[base], t)
end

TARDIS_OVERRIDES = TARDIS_OVERRIDES or {}
local cat_overrides = TARDIS_OVERRIDES.Categories or {}
local name_overrides = TARDIS_OVERRIDES.Names or {}

local default_category = TARDIS_OVERRIDES.MainCategory or "Doctor Who - TARDIS"

TARDIS.MetadataTemplates = TARDIS.MetadataTemplates or {}

function TARDIS:AddInterior(t)
	self.Metadata[t.ID] = t
	self.MetadataRaw[t.ID] = t
	if t.Base and self.Metadata[t.Base] then
		self.Metadata[t.ID] = merge_interior(t.Base,t)
		self.Metadata[t.ID].Versions = self.MetadataRaw[t.ID].Versions
	end
	for k,v in pairs(self.MetadataRaw) do
		if t.ID == v.Base then
			self.Metadata[k] = merge_interior(v.Base,v)
			self.Metadata[k].Versions = self.MetadataRaw[k].Versions
		end
	end

	if t.Interior.Light and t.Interior.Light.override then 
		local lightOverride = table.Copy(self.Metadata[t.ID].Interior.Light)
		lightOverride.override = nil
		table.Merge(lightOverride,t.Interior.Light.override)
		table.CopyFromTo(lightOverride, self.Metadata[t.ID].Interior.Light.override)
	end
	
	if t.Templates then
		for i,template_body in ipairs(t.Templates) do
			local template = self.MetadataTemplates[template_body.id]

			if template then
				self.Metadata[t.ID] = create_merge_table(template, self.Metadata[t.ID])
			elseif template_body.fail then
				template_body.fail()
			end
		end
	end

	if t.Base ~= true and not t.Hidden and not t.IsVersionOf then

		if not self.Metadata[t.ID].Versions then self.Metadata[t.ID].Versions = {} end
		local versions = self.Metadata[t.ID].Versions

		if not versions.other then versions.other = {} end
		if not versions.custom then versions.custom = {} end

		if not versions.main then
			versions.main = { id = t.ID, }
		end
		if versions.randomize then
			versions.random_list = table.Copy(versions.other) or {}
			versions.random_list.main = versions.main
		end


		local ent={}

		local cat_override
		if cat_overrides then
			for category,cat_interiors in pairs(cat_overrides) do
				if table.HasValue(cat_interiors, t.ID) or table.HasValue(cat_interiors, t.Name) then
					cat_override = category
					break
				end
			end
		end

		local name_override = (name_overrides ~= nil) and (name_overrides[t.ID] or name_overrides[t.Name]) or nil

		ent.Category = cat_override or t.Category or default_category
		ent.PrintName = name_override or t.Name

		if CLIENT and TARDIS:IsFavoriteInt(t.ID, LocalPlayer()) then
			ent.PrintName = "  " .. ent.PrintName -- move to the top
		end

		local function try_icon(filename)
			if ent.IconOverride ~= nil then return end
			if file.Exists("materials/vgui/entities/" .. filename, "GAME") then
				ent.IconOverride="vgui/entities/" .. filename
			end
		end

		try_icon("tardis/" .. t.ID .. ".vmt")
		try_icon("tardis/" .. t.ID .. ".vtf")
		try_icon("tardis/" .. t.ID .. ".png")
		try_icon("tardis/default/" .. t.ID .. ".png")
		try_icon("tardis/gmod_tardis.vmt")

		ent.ScriptedEntityType="tardis"
		list.Set("SpawnableEntities", t.ID, ent)
	end
end

function TARDIS:AddInteriorTemplate(id, template)
	if not id or not template then return end
	self.MetadataTemplates[id] = template
end

function TARDIS:AddCustomVersion(main_id, version_id, version)
	if not self.Metadata[main_id] then return end

	local versions = self.Metadata[main_id].Versions

	if versions.allow_custom == false then return end
	if version_id == "main" then return end
	if versions.other[version_id] or versions.custom[version_id] then return end

	versions.custom[version_id] = version

	if versions.randomize and versions.randomize_custom then
		versions.random_list[version_id] = version
	end
end

function TARDIS:GetInterior(id)
	if self.Metadata[id] ~= nil then
		return self.Metadata[id]
	end
end

function TARDIS:GetInteriors()
	return self.Metadata
end

function TARDIS:SpawnByID(id)
	RunConsoleCommand("tardis2_spawn", id)
	surface.PlaySound("ui/buttonclickrelease.wav")
end



----------------------------------------------------------------------------------------------------
-- Menu-related helper functions

local function SetDefaultInterior(id)
	TARDIS:SetSetting("interior", id, true)
	TARDIS:Message(LocalPlayer(), "TARDIS default interior changed. Respawn the TARDIS for changes to apply.")
end

local function SelectForRedecoration(id)
	TARDIS:SetSetting("redecorate-interior", id, true)
	local current_tardis = LocalPlayer():GetTardisData("exterior")

	if not current_tardis or not current_tardis:GetData("redecorate") then
		TARDIS:Message(LocalPlayer(), "TARDIS interior decor selected. Enable redecoration in your TARDIS to apply.")
	else
		TARDIS:Message(LocalPlayer(), "TARDIS interior decor selected. Restart the redecoration to apply.")
	end
end

local function AddMenuLabel(dmenu, text)
	local label = vgui.Create("DLabel", dmenu)
	label:SetText("  " .. text)
	label:SetTextColor(Color(0,0,0))
	dmenu:AddPanel(label)
end

local function AddMenuSingleVersion(dmenu, id)
	local spawn = dmenu:AddOption("Spawn", function()
		TARDIS:SpawnByID(id)
	end)
	spawn:SetIcon("icon16/add.png")

	local select_default = dmenu:AddOption("Select as default interior", function()
		SetDefaultInterior(id)
	end)
	select_default:SetIcon("icon16/star.png")

	local select_redecoration = dmenu:AddOption("Select for redecoration", function()
		SelectForRedecoration(id)
	end)
	select_redecoration:SetIcon("icon16/color_wheel.png")
end

local function AddMenuDoubleVersion(dmenu, classic_doors_id, double_doors_id)
	AddMenuLabel(dmenu, "Classic doors version:")
	AddMenuSingleVersion(dmenu, classic_doors_id)

	dmenu:AddSpacer()

	AddMenuLabel(dmenu, "Double doors version:")
	AddMenuSingleVersion(dmenu, double_doors_id)
end

local function AddMenuVersion(dmenu, version)
	if version.classic_doors_id then
		AddMenuDoubleVersion(dmenu, version.classic_doors_id, version.double_doors_id)
	else
		AddMenuSingleVersion(dmenu, version.id)
	end

	dmenu:AddSpacer()

	local id = (version.classic_doors_id or version.id)

	local unwanted = dmenu:AddOption("Use in random redecoration", function(self)
		TARDIS:ToggleUnwantedInt(id , LocalPlayer(), version.double_doors_id)
	end)
	function unwanted:Think()
		local use = not TARDIS:IsUnwantedInt(id, LocalPlayer())
		if self:GetChecked() ~= use then
			self:SetChecked(use)
		end
	end
	unwanted:SetIsCheckable(true)

end

local function AddVersionSubMenu(dmenu, version)
	if not version or not version.name then return end

	local submenu = dmenu:AddSubMenu(version.name, function()
		TARDIS:SpawnByID( TARDIS:SelectDoorVersionID(version, LocalPlayer()) )
	end)
	AddMenuVersion(submenu, version)

	return submenu
end


----------------------------------------------------------------------------------------------------
-- Adding the spawnmenu options

hook.Add("PostGamemodeLoaded", "tardis-interiors", function()
	if not spawnmenu then return end
	spawnmenu.AddContentType("tardis", function(container, obj)
		if not obj.material then return end
		if not obj.nicename then return end
		if not obj.spawnname then return end

		local icon = vgui.Create("ContentIcon", container)
		icon:SetContentType("entity")
		icon:SetSpawnName(obj.spawnname)
		icon:SetName(obj.nicename)
		icon:SetMaterial(obj.material)
		icon:SetAdminOnly(obj.admin)
		icon:SetColor(Color(205, 92, 92, 255))

		icon.DoClick = function()
			local versions = TARDIS:GetInterior(obj.spawnname).Versions

			local version = versions.main
			if versions.randomize and versions.random_list then
				version = table.Random(versions.random_list)
			end

			TARDIS:SpawnByID( TARDIS:SelectDoorVersionID(version, LocalPlayer()) )
		end

		icon.OpenMenu = function(self)
			local dmenu = DermaMenu()
			local versions = TARDIS:GetInterior(obj.spawnname).Versions

			AddMenuVersion(dmenu, versions.main)
			dmenu:AddSpacer()

			for k,v in pairs(versions.other) do
				AddVersionSubMenu(dmenu, v)
			end
			dmenu:AddSpacer()

			for k,v in pairs(versions.custom) do
				AddVersionSubMenu(dmenu, v)
			end
			dmenu:AddSpacer()

			local favorite = dmenu:AddOption("Add to favorites (reload required)", function(self)
				TARDIS:ToggleFavoriteInt(obj.spawnname, LocalPlayer())
				TARDIS:Message(LocalPlayer(), "Reload the game for changes to apply")
				TARDIS:Message(LocalPlayer(), "Favorites have been updated")
			end)
			favorite:SetIsCheckable(true)
			function favorite:Think()
				local fav = TARDIS:IsFavoriteInt(obj.spawnname, LocalPlayer())
				if self:GetChecked() ~= fav then
					self:SetChecked(fav)
				end
			end

			dmenu:Open()
		end

		if IsValid(container) then
			container:Add(icon)
		end

		return icon
	end)
end)

if SERVER then
	function TARDIS:SpawnTARDIS(ply, customData)
		local entityName = "gmod_tardis"
		
		local metadataID = customData.metadataID

		if not (TARDIS:GetInterior(metadataID) and IsValid(ply) and gamemode.Call("PlayerSpawnSENT", ply, entityName)) then return end

		local vStart = ply:EyePos()
		local vForward = ply:GetAimVector()

		local tr
		if not customData.pos then
			local trace = {}
			trace.start = vStart
			trace.endpos = vStart + (vForward * 4096)
			trace.filter = ply

			tr = util.TraceLine(trace)
		end

		local sent = scripted_ents.GetStored(entityName).t
		ClassName = entityName
		local SpawnFunction = scripted_ents.GetMember(entityName, "SpawnFunction")
		if not SpawnFunction then
			return
		end
		local entity = SpawnFunction(sent, ply, tr, entityName, customData)

		if IsValid(entity) then
			entity:SetCreator(ply)
		end

		ClassName = nil

		local interior = TARDIS:GetInterior(metadataID)
		local printName = "TARDIS ("..interior.Name..")"

		if not IsValid(entity) then return end

		if IsValid(ply) then
			gamemode.Call("PlayerSpawnedSENT", ply, entity)
		end

		undo.Create("SENT")
		undo.SetPlayer(ply)
		undo.AddEntity(entity)
		if customData.redecorate_parent then
			undo.AddEntity(customData.redecorate_parent)
		end
		undo.SetCustomUndoText("Undone " .. printName)
		undo.Finish(printName)

		ply:AddCleanup("sents", entity)
		entity:SetVar("Player", ply)

		if TARDIS:GetSetting("randomize_skins", true, entity:GetCreator()) then
			local total_skins = entity:SkinCount()
			if total_skins then
				local chosen_skin = math.random(total_skins)

				local excluded = entity.metadata.Exterior.ExcludedSkins
				if excluded then
					local attempts = 1
					while table.HasValue(excluded, chosen_skin) and attempts < 20 do
						chosen_skin = math.random(total_skins)
						attempts = attempts + 1
					end
				end
				if not excluded or not table.HasValue(excluded, chosen_skin) then
					entity:SetSkin(chosen_skin)
					entity:SetData("intdoor_skin_needs_update", true, true)
				end
			end
		end

		return entity
	end
	concommand.Add("tardis2_spawn", function(ply, cmd, args)
		TARDIS:SpawnTARDIS(ply, {metadataID = args[1]})
	end)
end

TARDIS:LoadFolder("interiors/templates", nil, true)
TARDIS:LoadFolder("interiors", nil, true)
TARDIS:LoadFolder("interiors/versions", nil, true)