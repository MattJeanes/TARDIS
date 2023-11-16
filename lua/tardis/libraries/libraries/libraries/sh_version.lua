-- Version

TARDIS.Migrations = TARDIS.Migrations or {}

local function get_version_from_string(str)
    local major, minor, patch = string.match(str, "^(%d+)%.(%d+)%.(%d+)$")
    if not major then return false end
    return true, {
        Major = tonumber(major),
        Minor = tonumber(minor),
        Patch = tonumber(patch)
    }
end

local function get_version_from_file(versionFile)
    local version
    if file.Exists(versionFile, "DATA") then
        local versionStr = file.Read(versionFile, "DATA")
        local success, version = get_version_from_string(versionStr)
        if not success then
            error("Invalid version in ".. versionFile .. ": " .. versionStr)
        end
        version = version
    else
        version = {
            Major = 0,
            Minor = 0,
            Patch = 0
        }
    end

    return version
end

local VERSION_FILE = "tardis/version" .. (SERVER and "_sv" or "_cl") .. ".txt"
local VERSION_LAST_USED_FILE = "tardis/version_lastused" .. (SERVER and "_sv" or "_cl") .. ".txt"

local function get_previous_version()
    return get_version_from_file(VERSION_FILE)
end

local function get_last_used_version()
    return get_version_from_file(VERSION_LAST_USED_FILE)
end

TARDIS.PreviousVersion = TARDIS.PreviousVersion or get_previous_version()
TARDIS.LastUsedVersion = TARDIS.LastUsedVersion or get_last_used_version()

function TARDIS:GetVersion()
    return self.Version
end

function TARDIS:GetPreviousVersion()
    return self.PreviousVersion
end

function TARDIS:GetLastUsedVersion()
    return self.LastUsedVersion
end

function TARDIS:SetLastUsedVersion()
    if self:IsVersionEqualTo(self:GetVersionString(), self:GetVersionString(self.LastUsedVersion)) then
        print("[TARDIS] Last used version is the same as current version")
        return
    end
    file.Write(VERSION_LAST_USED_FILE, self:GetVersionString())
    self.LastUsedVersion = self:GetVersion()
end

function TARDIS:IsNewVersion()
    if self.LastUsedVersion.Major == 0
        and self.LastUsedVersion.Minor == 0
        and self.LastUsedVersion.Patch == 0
    then
        -- We need to try and determine if this is a new install or an update
        -- If the version file doesn't exist, it would normally be a new install
        -- However, this feature was added in 2023.8.0, so if that's the current version
        -- and we are within two weeks of the release date, we can assume it's an update

        -- This code can be removed after 2023.8.0 has been out for two weeks
        -- and this can always return false if the version file doesn't exist

        local releaseDate = os.time({year=2023, month=11, day=23, hour=0, min=0, sec=0})
        local now = os.time()
        local twoWeeks = 60 * 60 * 24 * 14
        if (now - releaseDate) < twoWeeks then
            return true
        else
            return false
        end
    end
    return self:IsVersionHigherThan(self:GetVersionString(self.LastUsedVersion))
end

function TARDIS:GetVersionString(version)
    version = version or self.Version
    return string.format("%d.%d.%d", version.Major, version.Minor, version.Patch)
end

local function get_versions(versionStr, compareVersionStr)
    local success, version = get_version_from_string(versionStr)
    if not success then
        error("Invalid version string: " .. versionStr)
    end

    local compareVersion
    if compareVersionStr then
        success, compareVersion = get_version_from_string(compareVersionStr)
        if not success then
            error("Invalid version string: " .. compareVersionStr)
        end
    else
        compareVersion = TARDIS.Version
    end

    return version, compareVersion
end

function TARDIS:IsVersionHigherOrEqualTo(versionStr, compareVersionStr)
    local version, compareVersion = get_versions(versionStr, compareVersionStr)

    if compareVersion.Major > version.Major then return true end
    if compareVersion.Major < version.Major then return false end

    if compareVersion.Minor > version.Minor then return true end
    if compareVersion.Minor < version.Minor then return false end

    if compareVersion.Patch >= version.Patch then return true end

    return false
end

function TARDIS:IsVersionHigherThan(versionStr, compareVersionStr)
    local version, compareVersion = get_versions(versionStr, compareVersionStr)

    if compareVersion.Major > version.Major then return true end
    if compareVersion.Major < version.Major then return false end

    if compareVersion.Minor > version.Minor then return true end
    if compareVersion.Minor < version.Minor then return false end

    if compareVersion.Patch > version.Patch then return true end

    return false
end

function TARDIS:IsVersionEqualTo(versionStr, compareVersionStr)
    local version, compareVersion = get_versions(versionStr, compareVersionStr)

    if compareVersion.Major ~= version.Major then return false end
    if compareVersion.Minor ~= version.Minor then return false end
    if compareVersion.Patch ~= version.Patch then return false end

    return true
end

function TARDIS:AddMigration(name, fromVersion, func)
    local source = debug.getinfo(2).short_src

    if not TARDIS:IsVersionHigherOrEqualTo(fromVersion) then
        error("Invalid version for migration '".. name .."': " .. fromVersion .. " (current version is " .. self:GetVersionString() .. ")")
    end

    if self.Migrations[fromVersion] and self.Migrations[fromVersion][name] and self.Migrations[fromVersion][name].source ~= source then
        error("Duplicate migration registered: " .. name .. "(" .. fromVersion .. ") (exists in both " .. self.Migrations[fromVersion][name].source .. " and " .. source .. ")")
    end

    local success = get_version_from_string(fromVersion)
    if not success then
        error("Invalid version in migration: " .. fromVersion)
    end

    if self.Migrations[fromVersion] == nil then
        self.Migrations[fromVersion] = {}
    end
    self.Migrations[fromVersion][name] = {
        func = func,
        source = source
    }
end

function TARDIS:RunMigrations()
    local versions = table.GetKeys(self.Migrations)
    if #versions == 0 then return end

    local filteredVersions = {}
    local previousVersionStr = self:GetVersionString(get_previous_version())
    for _, version in ipairs(versions) do
        if self:IsVersionHigherThan(previousVersionStr, version) then
            table.insert(filteredVersions, version)
        end
    end

    table.sort(filteredVersions, function(a,b)
        return self:IsVersionHigherThan(a,b)
    end)

    for _, version in ipairs(filteredVersions) do
        for name, migration in pairs(self.Migrations[version]) do
            print("[TARDIS] Running migration " .. name .. " (" .. version .. ")")
            migration.func(self)
        end
    end
    file.Write(VERSION_FILE, self:GetVersionString())
end
