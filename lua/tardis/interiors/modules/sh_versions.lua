function TARDIS:SetupVersions(int_id)
    local t = self.MetadataRaw[int_id]

    if t.Base == true or t.Hidden or t.IsVersionOf then
        return
    end

    local versions

    if t.Versions then
        versions = table.Copy(t.Versions)
    else
        versions = {}
    end

    versions.other = versions.other or {}
    versions.custom = versions.custom or {}
    versions.main = versions.main or { id = int_id, }

    versions.list_original = table.Copy(versions.other) or {}
    versions.list_all = table.Copy(versions.other) or {}
    versions.list_original.main = versions.main
    versions.list_all.main = versions.main

    self.MetadataVersions[int_id] = versions

    local custom_versions = self.MetadataCustomVersions[int_id]
    if custom_versions then
        for version_id,version in pairs(custom_versions) do
            self:SetupCustomVersion(int_id, version_id, version)
        end
    end
end

function TARDIS:ShouldUseClassicDoors(ply)
    return TARDIS:GetSetting("use_classic_door_interiors", ply)
end

function TARDIS:SelectDoorVersionID(x, ply)
    local version = (istable(x) and x) or self.MetadataVersions[x].main
    if not version then return end

    if not version.classic_doors_id then return version.id end

    local use_classic = TARDIS:ShouldUseClassicDoors(ply)
    local custom = TARDIS:GetCustomSetting(version.classic_doors_id, "preferred_door_type", ply, nil)

    if custom ~= nil and custom ~= "default" then
        if custom == "classic" then
            return version.classic_doors_id
        end
        if custom == "double" then
            return version.double_doors_id
        end
        if custom == "random" then
            use_classic = (math.random(0, 1) == 1)
        end
    end

    return (use_classic and version.classic_doors_id) or version.double_doors_id
end


function TARDIS:DefaultPreferredVersion(int_id)
    local int_id = TARDIS:GetMainVersionId(int_id)
    local versions = self.MetadataVersions[int_id]

    if versions and versions.randomize_custom and not table.IsEmpty(versions.custom) then
        return "random_custom"
    end

    if versions and versions.randomize and not table.IsEmpty(versions.other) then
        return "random"
    end

    return "main"
end

function TARDIS:SelectSpawnID(id, ply)
    local versions = self.MetadataVersions[id]
    if not versions then return id end

    local preferred_version = TARDIS:GetCustomSetting(id, "preferred_version", ply, "main")

    local version = versions.main

    if istable(preferred_version) then
        version = preferred_version
    elseif preferred_version == "random_custom" and versions.list_all then
        version = table.Random(versions.list_all)
    elseif preferred_version == "random" and versions.list_original then
        version = table.Random(versions.list_original)
    elseif preferred_version == "main" then
        version = versions.main
    else
        version = id
    end

    return TARDIS:SelectDoorVersionID(version, ply)
end

function TARDIS:GetMainVersionId(int_id)
    return (self.Metadata[int_id] and self.Metadata[int_id].IsVersionOf) or int_id
end

function TARDIS:SetupCustomVersion(main_id, version_id, version)
    local versions = self.MetadataVersions[main_id]

    if versions and versions.allow_custom ~= false then
        if versions.other[version_id] or versions.custom[version_id] then return end

        versions.custom[version_id] = version
        versions.list_all[version_id] = version
    end
end

function TARDIS:AddCustomVersion(main_id, version_id, version)
    if version_id == "main" then return end

    self.MetadataCustomVersions[main_id] = self.MetadataCustomVersions[main_id] or {}
    local custom_versions = self.MetadataCustomVersions[main_id]

    custom_versions[version_id] = version
    if self.MetadataVersions[main_id] then
        self:SetupCustomVersion(main_id, version_id, version)
    end

end


----------------------------------------------------------------------------------------------------
-- Redecoration

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