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

function TARDIS:GetCustomSetting(int_id, setting_id, ply, default_val)
    local int_id = TARDIS:GetMainVersionId(int_id)
    local metadata = self.Metadata[int_id]

    local int_pref = TARDIS:GetIntPreferences(ply)
    if not int_pref or not int_pref.custom_settings then return default_val end

    local settings = int_pref.custom_settings[int_id]
    if settings and settings[setting_id] ~= nil then
        return settings[setting_id]
    end

    if setting_id == "preferred_version" then
        return TARDIS:SetupPreferredVersion(int_id, ply)
    end

    -- getting the default setting value from metadata and saving it for the user
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

function TARDIS:SetupPreferredVersion(int_id, ply)
    local int_id = TARDIS:GetMainVersionId(int_id)
    local metadata = self.Metadata[int_id]
    local versions = metadata and metadata.Versions

    local preferred_version = "main"

    if versions and versions.randomize and versions.randomize_custom
        and not table.IsEmpty(versions.custom)
    then
        preferred_version = "random_custom"
    elseif versions and versions.randomize
        and not table.IsEmpty(versions.other)
    then
        preferred_version = "random"
    end

    TARDIS:SetCustomSetting(int_id, "preferred_version", preferred_version, ply)
    return preferred_version
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