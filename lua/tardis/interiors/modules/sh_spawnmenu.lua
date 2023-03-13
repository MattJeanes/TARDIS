function TARDIS:SpawnByID(id)
    RunConsoleCommand("tardis2_spawn", id)
    surface.PlaySound("ui/buttonclickrelease.wav")
end

if CLIENT then
    local function SelectForRedecoration(id)
        TARDIS:SetSetting("redecorate-interior", id)
        local current_tardis = LocalPlayer():GetTardisData("exterior")

        if not current_tardis or not current_tardis:GetData("redecorate") then
            TARDIS:Message(LocalPlayer(), "Spawnmenu.RedecorationSelected")
        else
            TARDIS:Message(LocalPlayer(), "Spawnmenu.RedecorationSelectedRestart")
        end
    end

    local function AddMenuLabel(dmenu, text)
        local label = vgui.Create("DLabel", dmenu)
        label:SetText("  " .. TARDIS:GetPhrase(text))
        label:SetTextColor(Color(0,0,0))
        dmenu:AddPanel(label)
    end

    local function AddMenuSingleVersion(dmenu, id)
        local spawn = dmenu:AddOption(TARDIS:GetPhrase("Spawnmenu.Spawn"), function()
            TARDIS:SpawnByID(id)
        end)
        spawn:SetIcon("icon16/add.png")

        local select_redecoration = dmenu:AddOption(TARDIS:GetPhrase("Spawnmenu.SelectForRedecoration"), function()
            SelectForRedecoration(id)
        end)
        select_redecoration:SetIcon("icon16/color_wheel.png")
    end

    local function AddMenuDoubleVersion(dmenu, classic_doors_id, double_doors_id)
        AddMenuLabel(dmenu, "Spawnmenu.ClassicDoorsVersion")
        AddMenuSingleVersion(dmenu, classic_doors_id)

        dmenu:AddSpacer()

        AddMenuLabel(dmenu, "Spawnmenu.DoubleDoorsVersion")
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

        local submenu = dmenu:AddSubMenu(TARDIS:GetPhrase(version.name), function()
            TARDIS:SpawnByID( TARDIS:SelectDoorVersionID(version, LocalPlayer()) )
        end)
        AddMenuVersion(submenu, version)

        return submenu
    end

    local function AddMenuBoolSetting(dmenu, int_id, setting_id, name)
        local setting_button = dmenu:AddOption(TARDIS:GetPhrase(name), function(self)
            TARDIS:ToggleCustomSetting(int_id, setting_id)
        end)
        setting_button:SetIsCheckable(true)

        function setting_button:Think()
            local value = TARDIS:GetCustomSetting(int_id, setting_id, LocalPlayer(), false)
            if self:GetChecked() ~= value then
                self:SetChecked(value)
            end
        end

        return setting_button
    end

    local function AddMenuListSetting(dmenu, int_id, setting_id, name, options, compare_func)
        local submenu = dmenu:AddSubMenu(TARDIS:GetPhrase(name), nil)

        local option_buttons = {}

        if not options then return end
        for option_value, option_text in SortedPairsByValue(options) do

            local option_button = submenu:AddOption(TARDIS:GetPhrase(option_text), function(self)
                TARDIS:SetCustomSetting(int_id, setting_id, option_value)
            end)
            option_button:SetIsCheckable(true)

            table.insert(option_buttons, {option_value, option_button})
        end

        function submenu:Think()
            local value = TARDIS:GetCustomSetting(int_id, setting_id, LocalPlayer())
            for i,v in ipairs(option_buttons) do
                local checked = (value == v[1])
                if compare_func then
                    checked = compare_func(value, v[1])
                end
                v[2]:SetChecked(checked)
            end
        end

    end

    local function AddSettingsSubmenu(parent, int_id)
        local int_id = TARDIS:GetMainVersionId(int_id)

        local versions = TARDIS.MetadataVersions[int_id]
        local custom_settings = TARDIS.IntCustomSettings[int_id]

        local other_versions_exist = not table.IsEmpty(versions.other)
        local custom_versions_exist = not table.IsEmpty(versions.custom)

        local versions_exist = other_versions_exist or custom_versions_exist
        local dmenu = parent:AddSubMenu(TARDIS:GetPhrase("Spawnmenu.Settings"), nil)

        if versions_exist then

            local option_versions = {}

            local function add_version_option(option_name, option_id, order)
                local prefixes = { "  ", "  ", "  ", "  " } -- spaces are different symbols
                option_versions[option_id] = prefixes[order] .. TARDIS:GetPhrase(option_name)
            end

            add_version_option("Spawnmenu.VersionOptions.Default", "main", 1)

            if other_versions_exist then
                add_version_option("Spawnmenu.VersionOptions.Random", "random", 2)
            end
            if custom_versions_exist then
                add_version_option("Spawnmenu.VersionOptions.RandomOriginal", "random", 2)
                add_version_option("Spawnmenu.VersionOptions.RandomOriginalAndCustom", "random_custom", 2)
            end

            if other_versions_exist then
                for k,v in SortedPairs(versions.other) do
                    add_version_option(v.name, v, 3)
                end
            end
            if custom_versions_exist then
                for k,v in SortedPairs(versions.custom) do
                    add_version_option(v.name, v, 4)
                end
            end

            local function versions_compare(a, b)
                if istable(a) ~= istable(b) then return false end
                if not istable(a) then
                    return (a == b)
                end
                local ok = true
                ok = ok and (a.id == b.id)
                ok = ok and (a.classic_doors_id == b.classic_doors_id)
                ok = ok and (a.double_doors_id == b.double_doors_id)
                return ok
            end

            AddMenuListSetting(dmenu, int_id, "preferred_version", "Spawnmenu.PreferredVersion", option_versions, versions_compare)
        end

        local function search_for_double_versions(version_list, current_val)
            if current_val then return true end
            for k,v in pairs(version_list) do
                if v.classic_doors_id then
                    return true
                end
            end
            return false
        end

        local has_double_versions = (versions.main.classic_doors_id ~= nil)
        has_double_versions = search_for_double_versions(versions.other, has_double_versions)
        has_double_versions = search_for_double_versions(versions.custom, has_double_versions)

        if has_double_versions then
            AddMenuListSetting(dmenu, int_id, "preferred_door_type", "Spawnmenu.PreferredDoorType", {
                ["default"] = " ".. TARDIS:GetPhrase("Spawnmenu.PreferredDoorType.Default"),
                ["random"] = " ".. TARDIS:GetPhrase("Spawnmenu.PreferredDoorType.Random"),
                ["classic"] = " " .. TARDIS:GetPhrase("Spawnmenu.PreferredDoorType.Classic"),
                ["double"] = " " .. TARDIS:GetPhrase("Spawnmenu.PreferredDoorType.Double"),
            })
        end

        AddMenuBoolSetting(dmenu, int_id, "redecoration_exclude", "Spawnmenu.RedecorationExclude")

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

        local reset_button = dmenu:AddOption(TARDIS:GetPhrase("Spawnmenu.ResetSettings"), function(self)
            TARDIS:ResetCustomSettings(int_id)
        end)

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
    
            icon.DoClick = function()
                local id = TARDIS:SelectSpawnID(obj.spawnname, LocalPlayer())
                TARDIS:SpawnByID(id)
            end
    
            icon.OpenMenu = function(self)
                local dmenu = DermaMenu()
                local versions = TARDIS.MetadataVersions[obj.spawnname]

                if versions then
                    AddMenuVersion(dmenu, versions.main)
                    dmenu:AddSpacer()
        
                    if not table.IsEmpty(versions.other) then
                        AddMenuLabel(dmenu, "Spawnmenu.AlternativeVersions")
                        for k,v in SortedPairs(versions.other) do
                            AddVersionSubMenu(dmenu, v)
                        end
                        dmenu:AddSpacer()
                    end
        
                    if not table.IsEmpty(versions.custom) then
                        AddMenuLabel(dmenu, "Spawnmenu.CustomVersions")
                        for k,v in SortedPairs(versions.custom) do
                            AddVersionSubMenu(dmenu, v)
                        end
                        dmenu:AddSpacer()
                    end
                end
    
                local favorite = dmenu:AddOption(TARDIS:GetPhrase("Spawnmenu.AddToFavourites"), function(self)
                    TARDIS:ToggleFavoriteInt(obj.spawnname)
                    TARDIS:Message(LocalPlayer(), "Spawnmenu.ReloadGame")
                    TARDIS:Message(LocalPlayer(), "Spawnmenu.FavoritesUpdated")
                end)
                favorite:SetIcon("icon16/heart_add.png")
                function favorite:Think()
                    local fav = TARDIS:IsFavoriteInt(obj.spawnname, LocalPlayer())
                    local fav_icon = fav and "heart_delete.png" or "heart_add.png"
                    local fav_text = fav and "Spawnmenu.RemoveFromFavourites" or "Spawnmenu.AddToFavourites"
                    self:SetIcon("icon16/" .. fav_icon)
                    self:SetText(TARDIS:GetPhrase(fav_text))
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

    hook.Add("TARDIS_LanguageChanged", "tardis-spawnmenu", function()
        for k,v in pairs(TARDIS:GetInteriors()) do
            TARDIS:SetupSpawnmenuIcon(k)
        end
        RunConsoleCommand("spawnmenu_reload")
    end)
end

TARDIS_OVERRIDES = TARDIS_OVERRIDES or {}
local c_overrides = TARDIS_OVERRIDES.Categories or {}
local n_overrides = TARDIS_OVERRIDES.Names or {}

function TARDIS:SetupSpawnmenuIcon(id)
    local t = self.MetadataRaw[id]

    if t.Base == true or t.Hidden or t.IsVersionOf then
        return
    end
    
    local ent={}

    local cat_override
    if c_overrides then
        for category,cat_interiors in pairs(c_overrides) do
            if table.HasValue(cat_interiors, t.ID) or table.HasValue(cat_interiors, t.Name) then
                cat_override = category
                break
            end
        end
    end

    local name_override = (n_overrides ~= nil) and (n_overrides[t.ID] or n_overrides[t.Name]) or nil

    local default_category = TARDIS_OVERRIDES.MainCategory or "#TARDIS.Spawnmenu.Category"

    ent.Category = cat_override or t.Category or default_category
    ent.PrintName = TARDIS:GetPhrase(name_override or t.Name)

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

