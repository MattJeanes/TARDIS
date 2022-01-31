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

local function merge(base,t)
	local copy=table.Copy(TARDIS.Metadata[base])
	table.Merge(copy,t)
	return copy
end

function TARDIS:AddInterior(t)
	self.Metadata[t.ID]=t
	self.MetadataRaw[t.ID]=t
	if t.Base and self.Metadata[t.Base] then
		self.Metadata[t.ID]=merge(t.Base,t)
	end
	for k,v in pairs(self.MetadataRaw) do
		if t.ID==v.Base then
			self.Metadata[k]=merge(v.Base,v)
		end
	end

	local is_additional = (t.Versions and not t.Versions.main == t.ID)

	if t.Base ~= true and not is_additional then
		local ent={}

		-- this is for developer debugging purposes only
		local spm_overrides = DEBUG_TARDIS_SPAWNMENU_CATEGORY_OVERRIDES

		if spm_overrides ~= nil and (spm_overrides[t.ID] or spm_overrides[t.Name]) then
			if spm_overrides[t.ID] then
				ent.Category = spm_overrides[t.ID]
			else
				ent.Category = spm_overrides[t.Name]
			end
		elseif t.Category ~= nil then
			ent.Category = t.Category
		elseif spm_overrides ~= nil and spm_overrides["all"] then
			ent.Category = spm_overrides["all"]
		else
			ent.Category = "Doctor Who - TARDIS"
		end

		local nm_overrides = DEBUG_TARDIS_SPAWNMENU_NAME_OVERRIDES

		if nm_overrides ~= nil and (nm_overrides[t.ID] or nm_overrides[t.Name]) then
			if nm_overrides[t.ID] then
				ent.PrintName = nm_overrides[t.ID]
			else
				ent.PrintName = nm_overrides[t.Name]
			end
		else
			ent.PrintName = t.Name
		end

		if file.Exists("materials/vgui/entities/tardis/"..t.ID..".vmt", "GAME")
		then
			ent.IconOverride="vgui/entities/tardis/"..t.ID..".vmt"

		elseif file.Exists("materials/vgui/entities/tardis/"..t.ID..".vtf", "GAME")
		then
			ent.IconOverride="vgui/entities/tardis/"..t.ID..".vtf"

		elseif file.Exists("materials/vgui/entities/tardis/"..t.ID..".png", "GAME")
		then
			ent.IconOverride="vgui/entities/tardis/"..t.ID..".png"
		else
			ent.IconOverride="vgui/entities/tardis/default/"..t.ID..".png"
		end
		ent.ScriptedEntityType="tardis"
		list.Set("SpawnableEntities", t.ID, ent)
	end
end

function TARDIS:GetInterior(id)
	if self.Metadata[id]~= nil then
		return self.Metadata[id]
	end
end

function TARDIS:GetInteriors()
	return self.Metadata
end

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

local function SpawnTARDISById(id)
	RunConsoleCommand("tardis2_spawn", id)
	surface.PlaySound("ui/buttonclickrelease.wav")
end

local function AddMenuVersion(dmenu, id)
	dmenu:AddOption("Spawn", function()
		SpawnTARDISById(id)
	end):SetIcon("icon16/add.png")

	dmenu:AddOption("Select as default interior", function()
		SetDefaultInterior(id)
	end):SetIcon("icon16/star.png")

	dmenu:AddOption("Select for redecoration", function()
		SelectForRedecoration(id)
	end):SetIcon("icon16/color_wheel.png")
end

local function AddVersionSubMenu(dmenu, name, id)
	local submenu = dmenu:AddSubMenu(name, function()
		SpawnTARDISById(id)
	end)
	AddMenuVersion(submenu, id)
	return submenu
end

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

		local versions = TARDIS:GetInterior(obj.spawnname).Versions

		if versions then
			versions.custom = versions.custom or {}
			for k,v in pairs(TARDIS.MetadataRaw) do
				if v.Versions and v.Versions.main == obj.spawnname and v.Versions.custom then
					table.Merge(versions.custom, v.Versions.custom)
				end
			end

			local function spawn_one_of_versions()
				local default_is_selected = true
				local selected_version
				local id

				if versions.custom and versions.randomize then
					local r = math.random(0, table.Count(versions.custom))
					default_is_selected = (r == 0)
				end

				if default_is_selected then
					selected_version = versions
				else
					selected_version = table.Random(versions.custom)
				end

				if selected_version.classic_doors_id then
					if TARDIS:GetSetting("use_classic_door_interiors", true, LocalPlayer()) then
						id = selected_version.classic_doors_id
					else
						id = selected_version.double_doors_id
					end
				elseif default_is_selected then
					id = obj.spawnname
				else
					id = selected_version.id
				end

				SpawnTARDISById(id)
			end

			icon.DoClick = spawn_one_of_versions
		else
			icon.DoClick = function()
				SpawnTARDISById(obj.spawnname)
			end
		end

		icon.OpenMenu = function(self)
			local dmenu = DermaMenu()

			if not versions or not versions.classic_doors_id then
				AddMenuVersion(dmenu, obj.spawnname)
			else
				local id
				if TARDIS:GetSetting("use_classic_door_interiors", true, LocalPlayer()) then
					id = versions.classic_doors_id
				else
					id = versions.double_doors_id
				end

				AddMenuVersion(dmenu, id)

				dmenu:AddSpacer()
				AddVersionSubMenu(dmenu, "Classic doors version", versions.classic_doors_id)
				AddVersionSubMenu(dmenu, "Double doors version", versions.double_doors_id)
			end

			dmenu:AddSpacer()
			if versions and versions.custom then
				for k,v in pairs(versions.custom) do
					if v.classic_doors_id then
						AddVersionSubMenu(dmenu, v.name .. " (classic doors)", v.classic_doors_id)
						AddVersionSubMenu(dmenu, v.name .. " (double doors)", v.double_doors_id)
					else
						AddVersionSubMenu(dmenu, v.name, v.id)
					end
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

TARDIS:LoadFolder("interiors", nil, true)