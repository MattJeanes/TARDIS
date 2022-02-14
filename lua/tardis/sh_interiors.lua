-- Interiors

TARDIS.Metadata = {}
TARDIS.MetadataRaw = {}
TARDIS.MetadataTemplates = {}

TARDIS:AddSetting({
    id="randomize_skins",
    name="Randomize TARDIS skins at spawn",
    value=true,
    type="bool",
    networked=true,
    option=true,
    section="Misc",
    desc="Whether or not TARDIS skin will be randomized when it's spawned"
})

TARDIS:AddSetting({
    id="winter_skins",
    name="Use winter skins while randomizing TARDIS skins at spawn",
    value=false,
    type="bool",
    networked=true,
    option=true,
    section="Misc",
    desc="Whether or not winter TARDIS skins will be used while it's randomized"
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

function TARDIS:SelectSpawnID(id, ply)
    local metadata = TARDIS:GetInterior(id)
    local versions = metadata and metadata.Versions
    if not versions then return id end

    local preferred_spawn = TARDIS:GetCustomSetting(id, "preferred_spawn", ply, "main")

    local version = versions.main

    if preferred_spawn == "random_custom" and versions.random_list_custom then
        version = table.Random(versions.random_list_custom)
    elseif preferred_spawn == "random" and versions.random_list then
        version = table.Random(versions.random_list)
    elseif preferred_spawn == "main" then
        version = versions.main
    else
        return preferred_spawn or id
    end

    return TARDIS:SelectDoorVersionID(version, ply)
end

----------------------------------------------------------------------------------------------------
-- Interior preferences (custom settings, favorites and excluded from redecoration)

local empty_int_preferences = {
    favorites = {},
    custom_settings = {},
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


----------------------------------------------------------------------------------------------------
-- Interior custom settings

function TARDIS:GetMainVersionId(int_id)
    return (self.Metadata[int_id] and self.Metadata[int_id].IsVersionOf) or int_id
end

function TARDIS:GetCustomSetting(int_id, setting_id, ply, default_val)
    local int_id = TARDIS:GetMainVersionId(int_id)
    local metadata = self.Metadata[int_id]

    local int_pref = TARDIS:GetIntPreferences(ply)
    if not int_pref or not int_pref.custom_settings then return default_val end

    local settings = int_pref.custom_settings[int_id]
    if settings and settings[setting_id] ~= nil then
        return settings[setting_id]
    end

    if setting_id == "preferred_spawn" then
        return TARDIS:SetupPreferredSpawn(int_id, ply)
    end

    local md_settings = metadata.CustomSettings
    if md_settings and md_settings[setting_id] and md_settings[setting_id].value ~= nil then
        local metadata_value = md_settings[setting_id].value
        TARDIS:SetCustomSetting(int_id, setting_id, metadata_value, ply)
        return metadata_value
    end

    return default_val
end

function TARDIS:SetCustomSetting(int_id, setting_id, value, ply)
    local int_id = TARDIS:GetMainVersionId(int_id)

    local int_pref = TARDIS:GetIntPreferences(ply)
    int_pref.custom_settings = int_pref.custom_settings or {}
    int_pref.custom_settings[int_id] = int_pref.custom_settings[int_id] or {}
    int_pref.custom_settings[int_id][setting_id] = value
    self:SaveIntPreferences(int_pref)
end

function TARDIS:ResetCustomSettings(ply, int_id)
    local int_id = TARDIS:GetMainVersionId(int_id)

    local int_pref = TARDIS:GetIntPreferences(ply)
    if not int_pref then return end

    if int_id then
        int_pref.custom_settings = int_pref.custom_settings or {}
        int_pref.custom_settings[int_id] = {}
    else
        int_pref.custom_settings = {}
    end

    self:SaveIntPreferences(int_pref)
end

function TARDIS:ToggleCustomSetting(int_id, setting_id, ply)
    local int_id = TARDIS:GetMainVersionId(int_id)

    local value = TARDIS:GetCustomSetting(int_id, setting_id, ply)
    TARDIS:SetCustomSetting(int_id, setting_id, (not value), ply)
end

function TARDIS:SetupPreferredSpawn(int_id, ply)
    local int_id = TARDIS:GetMainVersionId(int_id)
    local metadata = self.Metadata[int_id]
    local versions = metadata and metadata.Versions

    local preferred_spawn = "main"

    if versions and versions.randomize and versions.randomize_custom
        and not table.IsEmpty(versions.custom)
    then
        preferred_spawn = "random_custom"
    elseif versions and versions.randomize
        and not table.IsEmpty(versions.other)
    then
        preferred_spawn = "random"
    end

    TARDIS:SetCustomSetting(int_id, "preferred_spawn", preferred_spawn, ply)
    return preferred_spawn
end

----------------------------------------------------------------------------------------------------
-- Favorites

function TARDIS:IsFavoriteInt(id, ply)
    return TARDIS:GetIntPreferences(ply).favorites[id]
end

function TARDIS:SetFavoriteInt(id, favorite, ply)
    if favorite == false then favorite = nil end -- clean up (mainly for debugging purposes)

    local int_pref = TARDIS:GetIntPreferences(ply)
    int_pref.favorites[id] = favorite
    self:SaveIntPreferences(int_pref)
end

function TARDIS:ToggleFavoriteInt(id, ply)
    TARDIS:SetFavoriteInt(id, not TARDIS:IsFavoriteInt(id, ply), ply)
end

----------------------------------------------------------------------------------------------------
-- Exclude interiors from redecoration

function TARDIS:ShouldRedecorateInto(int_id, ply)
    local int_id = TARDIS:GetMainVersionId(int_id)
    return not TARDIS:GetCustomSetting(int_id, "redecoration_exclude", ply)
end

function TARDIS:SelectNewRandomInterior(current, ply)
    local current = TARDIS:GetMainVersionId(current)
    local chosen_int
    local attempts = 1000

    while not chosen_int or TARDIS:GetMainVersionId(chosen_int) == current
        or TARDIS.Metadata[chosen_int].IsVersionOf
        or TARDIS.Metadata[chosen_int].Base == true
        or not TARDIS:ShouldRedecorateInto(chosen_int, ply)
    do
        chosen_int = table.Random(TARDIS.Metadata).ID
        attempts = attempts - 1
        if attempts < 1 then
            return "default"
        end
    end

    return TARDIS:SelectSpawnID(TARDIS:GetMainVersionId(chosen_int), ply)
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

function TARDIS:FullReloadInteriors()
    self.Metadata = {}
    self.MetadataRaw = {}
    self.MetadataTemplates = {}
    TARDIS:LoadFolder("interiors/templates", nil, true)
    TARDIS:LoadFolder("interiors", nil, true)
    TARDIS:LoadFolder("interiors/versions", nil, true)
    TARDIS:MergeTemplates()
end

function TARDIS:AddInterior(t)
    if self.Metadata[t.ID] ~= nil and self.MetadataRaw[t.ID] ~= nil then
        TARDIS:FullReloadInteriors()
        return
    end

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

    if t.Base ~= true and not t.Hidden and not t.IsVersionOf then

        if not self.Metadata[t.ID].Versions then self.Metadata[t.ID].Versions = {} end
        local versions = self.Metadata[t.ID].Versions

        if not versions.other then versions.other = {} end
        if not versions.custom then versions.custom = {} end

        if not versions.main then
            versions.main = { id = t.ID, }
        end

        versions.random_list = table.Copy(versions.other) or {}
        versions.random_list_custom = table.Copy(versions.other) or {}
        versions.random_list.main = versions.main
        versions.random_list_custom.main = versions.main


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

local function AddInteriorPartsOffset(template, offset)
    local moved = table.Copy(template)

    for k,v in pairs(moved.Interior.Parts) do
        local new_pos = Vector(0,0,0)
        if v.pos then new_pos:Add(v.pos) end
        new_pos:Add(offset)
        v.pos = new_pos
    end

    for k,v in pairs(moved.Interior.PartTips) do
        local new_pos = Vector(0,0,0)
        if v.pos then new_pos:Add(v.pos) end
        new_pos:Add(offset)
        v.pos = (new_pos == Vector(0,0,0)) and nil or new_pos
        -- sometimes tip.pos needs to be nil
    end

    return moved
end

local function AddInteriorPartsRotation(template, rotate_ang)
    local rotated = table.Copy(template)

    for k,v in pairs(rotated.Interior.Parts) do
        local new_ang = Angle(0,0,0)
        local new_pos = Vector(0,0,0)

        if v.ang then new_ang:Add(v.ang) end
        if v.pos then new_pos:Add(v.pos) end

        new_ang:Add(rotate_ang)
        new_pos:Rotate(rotate_ang)

        v.pos = new_pos
        v.ang = new_ang
    end

    for k,v in pairs(rotated.Interior.PartTips) do
        local new_pos = Vector(0,0,0)
        if v.pos then new_pos:Add(v.pos) end
        new_pos:Rotate(rotate_ang)
        v.pos = (new_pos == Vector(0,0,0)) and nil or new_pos
        -- sometimes tip.pos needs to stay nil
    end

    return rotated
end


function TARDIS:MergeInteriorTemplates(cur_metadata, apply_conditions, ply)
    if not cur_metadata.Templates then
        return cur_metadata
    end

    local id = cur_metadata.ID
    local new_metadata = {}
    table.Merge(new_metadata, cur_metadata)
    -- we are not using table.Copy to avoid inheriting Vector and Angle objects

    for template_id, template in pairs(cur_metadata.Templates) do

        if template and template.realID then
            template_id = template.realID
        end

        local template_metadata = self.MetadataTemplates[template_id]

        if template and template_metadata
            and ((not apply_conditions and not template.condition)
                or (apply_conditions and template.condition and template.condition(id, ply)))
        then
            if template.parts_rotation then
                template_metadata = AddInteriorPartsRotation(template_metadata, template.parts_rotation)
            end
            if template.parts_offset then
                template_metadata = AddInteriorPartsOffset(template_metadata, template.parts_offset)
            end

            if template.override then
                new_metadata = create_merge_table(new_metadata, template_metadata)
            else
                new_metadata = create_merge_table(template_metadata, new_metadata)
            end

        elseif not template_metadata then
            if not template or not template.ignore_missing then
                local err_notification = "[TARDIS] Failed to find template " .. template_id .. " required for interior " .. id
                if CLIENT then
                    LocalPlayer():ChatPrint(err_notification)
                else
                    ErrorNoHalt("\n" .. err_notification)
                end
            end
            if template and template.fail_msg then
                if CLIENT then
                    LocalPlayer():ChatPrint(template.fail_msg)
                else
                    print("\n" .. template.fail_msg .. "\n")
                end
            end
            if template and template.fail then
                template.fail()
            end
        end
    end

    return new_metadata
end

function TARDIS:MergeTemplates()
    if not self.Metadata then return end

    for int_id, interior in pairs(self.Metadata) do
        self.Metadata[int_id] = TARDIS:MergeInteriorTemplates(self.Metadata[int_id], false)
    end
end

function TARDIS:AddInteriorTemplate(id, template)
    if not id or not template then return end

    if self.MetadataTemplates[id] ~= nil then
        TARDIS:FullReloadInteriors()
        return
    end

    self.MetadataTemplates[id] = template
end

function TARDIS:AddCustomVersion(main_id, version_id, version)
    if not self.Metadata[main_id] then return end

    local versions = self.Metadata[main_id].Versions

    if versions.allow_custom == false then return end
    if version_id == "main" then return end
    if versions.other[version_id] or versions.custom[version_id] then return end

    versions.custom[version_id] = version

    versions.random_list_custom[version_id] = version
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
end

local function AddVersionSubMenu(dmenu, version)
    if not version or not version.name then return end

    local submenu = dmenu:AddSubMenu(version.name, function()
        TARDIS:SpawnByID( TARDIS:SelectDoorVersionID(version, LocalPlayer()) )
    end)
    AddMenuVersion(submenu, version)

    return submenu
end

local function AddMenuBoolSetting(dmenu, int_id, setting_id, name)
    local ply = LocalPlayer()

    local setting_button = dmenu:AddOption(name, function(self)
        TARDIS:ToggleCustomSetting(int_id, setting_id, ply)
    end)
    setting_button:SetIsCheckable(true)

    function setting_button:Think()
        local value = TARDIS:GetCustomSetting(int_id, setting_id, ply, false)
        if self:GetChecked() ~= value then
            self:SetChecked(value)
        end
    end

    return setting_button
end

local function AddMenuListSetting(dmenu, int_id, setting_id, name, options)
    local ply = LocalPlayer()

    local submenu = dmenu:AddSubMenu(name, nil)

    local option_buttons = {}

    if not options then return end
    for option_value, option_text in SortedPairsByValue(options) do

        local option_button = submenu:AddOption(option_text, function(self)
            TARDIS:SetCustomSetting(int_id, setting_id, option_value, ply)
        end)
        option_button:SetIsCheckable(true)

        table.insert(option_buttons, {option_value, option_button})
    end

    function submenu:Think()
        local value = TARDIS:GetCustomSetting(int_id, setting_id, ply)
        for i,v in ipairs(option_buttons) do
            v[2]:SetChecked(value == v[1])
        end
    end

end

local function AddSettingsSubmenu(parent, int_id)
    local int_id = TARDIS:GetMainVersionId(int_id)

    local metadata = TARDIS:GetInterior(int_id)
    if not metadata then return end
    local versions = metadata.Versions
    local custom_settings = metadata.CustomSettings
    local ply = LocalPlayer()

    local other_versions_exist = not table.IsEmpty(versions.other)
    local custom_versions_exist = not table.IsEmpty(versions.custom)
    local main_version_double = (versions.main.classic_doors_id ~= nil)

    local versions_exist = other_versions_exist or custom_versions_exist or main_version_double
    local dmenu = parent:AddSubMenu("Settings", nil)

    if versions_exist then

        local option_versions = {
            ["main"] = "  Default", -- spaces are intentional (sorting)
        }

        if not table.IsEmpty(versions.custom) then
            option_versions["random_custom"] = "  Random (original & custom versions)"
            option_versions["random"] = "  Random (original versions only)"
        elseif not table.IsEmpty(versions.other) then
            option_versions["random"] = "  Random"
        end

        local function add_version_option(option_id, option_name)
            if not option_versions[option_id] then
                option_versions[option_id] = option_name
            end
        end

        if versions.main.classic_doors_id then
            add_version_option(versions.main.classic_doors_id, "  Classic doors version") -- spaces are intentional (sorting)
            add_version_option(versions.main.double_doors_id, "  Double doors version")
        end

        for k,v in SortedPairs(versions.other) do
            if v.classic_doors_id then
                add_version_option(v.classic_doors_id, "  " .. v.name .. " (classic doors)")
                add_version_option(v.double_doors_id, "  " .. v.name .. " (double doors)")
            else
                add_version_option(v.id, "  " .. v.name)
            end
        end

        if not table.IsEmpty(versions.custom) then
            for k,v in SortedPairs(versions.custom) do
                if v.classic_doors_id then
                    add_version_option(v.classic_doors_id, "  " .. v.name .. " (classic doors)")
                    add_version_option(v.double_doors_id, "  " .. v.name .. " (double doors)")
                else
                    add_version_option(v.id, "  " .. v.name)
                end
            end
        end

        AddMenuListSetting(dmenu, int_id, "preferred_spawn", "Preferred version", option_versions)
    end

    AddMenuBoolSetting(dmenu, int_id, "redecoration_exclude", "Exclude from random redecoration")

    if custom_settings then
        local custom_categories = {}

        for cust_setting_id, custom_setting in SortedPairs(custom_settings) do
            local custom_dmenu = dmenu

            if custom_setting.category then
                if not custom_categories[custom_setting.category] then
                    local submenu = dmenu:AddSubMenu(custom_setting.category, nil)
                    custom_categories[custom_setting.category] = submenu
                end
                custom_dmenu = custom_categories[custom_setting.category]
            end

            if custom_setting.value_type == "bool" then
                AddMenuBoolSetting(custom_dmenu, int_id, cust_setting_id, custom_setting.text)
            elseif custom_setting.value_type == "list" then
                AddMenuListSetting(custom_dmenu, int_id, cust_setting_id, custom_setting.text, custom_setting.options)
            end
        end

    end

    local reset_button = dmenu:AddOption("Reset settings", function(self)
        TARDIS:ResetCustomSettings(LocalPlayer(), int_id)
    end)

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
            local id = TARDIS:SelectSpawnID(obj.spawnname, LocalPlayer())
            TARDIS:SpawnByID(id)
        end

        icon.OpenMenu = function(self)
            local dmenu = DermaMenu()
            local versions = TARDIS:GetInterior(obj.spawnname).Versions

            AddMenuVersion(dmenu, versions.main)
            dmenu:AddSpacer()

            if not table.IsEmpty(versions.other) then
                AddMenuLabel(dmenu, "Alternative versions:")
                for k,v in SortedPairs(versions.other) do
                    AddVersionSubMenu(dmenu, v)
                end
                dmenu:AddSpacer()
            end

            if not table.IsEmpty(versions.custom) then
                AddMenuLabel(dmenu, "Custom versions:")
                for k,v in SortedPairs(versions.custom) do
                    AddVersionSubMenu(dmenu, v)
                end
                dmenu:AddSpacer()
            end

            local favorite = dmenu:AddOption("Add to favorites (reload required)", function(self)
                TARDIS:ToggleFavoriteInt(obj.spawnname, LocalPlayer())
                TARDIS:Message(LocalPlayer(), "Reload the game for changes to apply")
                TARDIS:Message(LocalPlayer(), "Favorites have been updated")
            end)
            favorite:SetIcon("icon16/heart_add.png")
            function favorite:Think()
                local fav = TARDIS:IsFavoriteInt(obj.spawnname, LocalPlayer())
                local fav_icon = fav and "heart_delete.png" or "heart_add.png"
                local fav_text = fav and "Remove from" or "Add to"
                self:SetIcon("icon16/" .. fav_icon)
                self:SetText(fav_text .. " favorites (reload required)")
            end

            AddSettingsSubmenu(dmenu, obj.spawnname)

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
                local winter = entity.metadata.Exterior.WinterSkins
                local winter_ok = TARDIS:GetSetting("winter_skins", false, entity:GetCreator())

                local function cannot_use_skin(chosen_skin)
                    local is_excluded = table.HasValue(excluded, chosen_skin)
                    return is_excluded or (not winter_ok and winter and table.HasValue(winter, chosen_skin) )
                end

                if excluded then
                    local attempts = 1
                    while cannot_use_skin(chosen_skin) and attempts < 30 do
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

TARDIS:FullReloadInteriors()
