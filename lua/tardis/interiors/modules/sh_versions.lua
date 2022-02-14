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

function TARDIS:InitializeVersions(int_id)
    local versions = self.Metadata[int_id].Versions or {}

    versions.other = versions.other or {}
    versions.custom = versions.custom or {}
    versions.main = versions.main or { id = int_id, }

    versions.random_list = table.Copy(versions.other) or {}
    versions.random_list_custom = table.Copy(versions.other) or {}
    versions.random_list.main = versions.main
    versions.random_list_custom.main = versions.main

    self.Metadata[int_id].Versions = versions
end

function TARDIS:ShouldUseClassicDoors(ply)
    return TARDIS:GetSetting("use_classic_door_interiors", true, ply)
end

function TARDIS:SelectDoorVersionID(x, ply)
    local version = (istable(x) and x) or TARDIS:GetInterior(x).Versions.main
    if not version then return end

    if not version.classic_doors_id then return version.id end

    local use_classic = TARDIS:ShouldUseClassicDoors(ply)
    return (use_classic and version.classic_doors_id) or version.double_doors_id
end


function TARDIS:InitPreferredVersionSetting(int_id, ply)
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

function TARDIS:SelectSpawnID(id, ply)
    local metadata = TARDIS:GetInterior(id)
    local versions = metadata and metadata.Versions
    if not versions then return id end

    local preferred_version = TARDIS:GetCustomSetting(id, "preferred_version", ply, "main")

    local version = versions.main

    if preferred_version == "random_custom" and versions.random_list_custom then
        version = table.Random(versions.random_list_custom)
    elseif preferred_version == "random" and versions.random_list then
        version = table.Random(versions.random_list)
    elseif preferred_version == "main" then
        version = versions.main
    else
        return preferred_version or id
    end

    return TARDIS:SelectDoorVersionID(version, ply)
end

function TARDIS:GetMainVersionId(int_id)
    return (self.Metadata[int_id] and self.Metadata[int_id].IsVersionOf) or int_id
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