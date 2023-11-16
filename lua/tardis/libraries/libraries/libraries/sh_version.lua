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


local versionFile = "tardis2_version.txt"
if file.Exists(versionFile, "DATA") then
    local previousVersionStr = file.Read(versionFile, "DATA")
    local success, version = get_version_from_string(previousVersionStr)
    if not success then
        error("Invalid version in version.txt: " .. previousVersionStr)
    end
    TARDIS.PreviousVersion = version
else
    TARDIS.PreviousVersion = {
        Major = 0,
        Minor = 0,
        Patch = 0
    }
end

function TARDIS:GetVersion()
    return self.Version
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

function TARDIS:RegisterMigration(name, fromVersion, func)
    if self:IsVersionHigherOrEqualTo(fromVersion, self:GetVersionString(self.PreviousVersion)) then
        if self.Migrations[fromVersion] then
            self.Migrations[fromVersion] = nil
        end
        return
    end

    local source = debug.getinfo(2).short_src

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
    local versionFile = "tardis2_version.txt"
    local versions = table.GetKeys(self.Migrations)
    if #versions == 0 then return end

    table.sort(versions, function(a,b)
        return TARDIS:IsVersionHigherThan(a,b)
    end)

    for _, version in ipairs(versions) do
        for name, migration in pairs(self.Migrations[version]) do
            print("[TARDIS] Running migration " .. name .. " (" .. version .. ")")
            migration.func()
        end
    end
    file.Write(versionFile, self:GetVersionString())
end


TARDIS:RegisterMigration("test", "2023.8.0", function()
    print("test migration 2023.8.0")
end)
