function TARDIS:GetCustomSettings(ply)
    return TARDIS:GetSetting("interior_custom_settings", ply) or {} -- nil is never allowed
end

function TARDIS:SetupCustomSettings(int_id)
    local csettings = {}

    local t = self.MetadataRaw[int_id]

    if t.CustomSettings then
        table.Merge(csettings, t.CustomSettings)
    end

    if t.Templates then
        for template_id, template in pairs(t.Templates) do
            if template and self.MetadataTemplates[template_id].CustomSettings then
                table.Merge(csettings, self.MetadataTemplates[template_id].CustomSettings)
            end
        end
    end

    self.IntCustomSettings[int_id] = csettings
end

function TARDIS:GetCustomSetting(int_id, setting_id, ply, default_val)
    local int_id = self:GetMainVersionId(int_id)

    local custom_settings = self:GetCustomSettings(ply)
    local settings = custom_settings[int_id]
    if settings and settings[setting_id] ~= nil then
        return settings[setting_id]
    end

    if setting_id == "preferred_version" then
        return self:DefaultPreferredVersion(int_id)
    end
    if setting_id == "preferred_door_type" then
        return "default"
    end

    -- getting the default setting value from metadata
    local md_settings = self.IntCustomSettings[int_id]
    if md_settings and md_settings[setting_id] and md_settings[setting_id].value ~= nil then
        local metadata_value = md_settings[setting_id].value
        return metadata_value
    end

    return default_val
end

if CLIENT then
    function TARDIS:SaveCustomSettings(settings)
        TARDIS:SetSetting("interior_custom_settings", settings)
    end

    function TARDIS:SetCustomSetting(int_id, setting_id, value)
        local int_id = self:GetMainVersionId(int_id)

        local custom_settings = self:GetCustomSettings(LocalPlayer())
        custom_settings[int_id] = custom_settings[int_id] or {}
        custom_settings[int_id][setting_id] = value
        self:SaveCustomSettings(custom_settings)
    end

    function TARDIS:ResetCustomSettings(int_id)
        local int_id = self:GetMainVersionId(int_id)

        if int_id == nil then
            self:SaveCustomSettings({})
            return
        end

        local custom_settings = self:GetCustomSettings(LocalPlayer())
        custom_settings[int_id] = {}
        self:SaveCustomSettings(custom_settings)
    end

    function TARDIS:ToggleCustomSetting(int_id, setting_id)
        local value = TARDIS:GetCustomSetting(int_id, setting_id, ply)
        TARDIS:SetCustomSetting(int_id, setting_id, (not value))
    end
end

----------------------------------------------------------------------------------------------------
-- Favorites

function TARDIS:IsFavoriteInt(id, ply)
    return self:GetCustomSetting(id, "is_favorite", ply, false)
end

if CLIENT then
    function TARDIS:SetFavoriteInt(id, favorite)
        self:SetCustomSetting(id, "is_favorite", favorite, ply)
    end

    function TARDIS:ToggleFavoriteInt(id)
        self:ToggleCustomSetting(id, "is_favorite")
    end
end