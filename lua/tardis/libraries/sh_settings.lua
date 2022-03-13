-- Settings

TARDIS.SettingsData = TARDIS.SettingsData or {}

TARDIS.GlobalSettings = TARDIS.GlobalSettings or {}
TARDIS.ClientSettings = TARDIS.ClientSettings or {}

if CLIENT then
    TARDIS.LocalSettings = TARDIS.LocalSettings or {}
    TARDIS.NetworkedSettings = TARDIS.NetworkedSettings or {}
end

--------------------------------------------------------------------------------
-- Setup

function TARDIS:AddSetting(data)
    self.SettingsData[data.id]=data
end

function TARDIS:GetSettingData(id)
    return self.SettingsData[id]
end

function TARDIS:GetSettingsData()
    return self.SettingsData
end

--------------------------------------------------------------------------------
-- Accessing

function TARDIS:SetSetting(id, value)
    local data = self.SettingsData[id]
    if not data then error("Requested setting ", id, " does not exist") end

    if data.type == "integer" then
        value = math.Round(value)
    end

    if SERVER then
        if data.class == "global" then
            self.GlobalSettings[id]=value
        else
            error("Setting " .. id .. " is being set serverside, but is not global")
        end
    else
        if data.class == "networked" then
            self.NetworkedSettings[id]=value
        elseif data.class == "local" then
            self.LocalSettings[id]=value
        else
            error("Setting " .. id .. " is being set clientside, but has unsupported class")
        end
    end

    self:SaveSettings()

    if (SERVER and data.class == "global") or (CLIENT and data.class == "networked") then
        self:SendSetting(id, value)
    end
end

function TARDIS:GetSetting(id, src)
    local ply
    if IsEntity(src) and src:IsPlayer() then
        ply = src
    elseif IsEntity(src) then
        ply = src:GetCreator()
    end

    if not id then error("Requested setting with no id") end
    local data = self.SettingsData[id]
    if not data then error("Requested setting " .. id .. " does not exist") end

    local function select_return_val(table_value)
        if table_value ~= nil then
            return table_value
        end
        return data.value
    end

    if data.class == "global" then
        return select_return_val(self.GlobalSettings[id])
    end

    if data.class == "local" then
        if SERVER then
            error("Local setting " .. id .. "is being requested serverside")
        end
        return select_return_val(self.LocalSettings[id])
    end

    if data.class == "networked" then

        if CLIENT and (ply == nil or ply == LocalPlayer()) then
            return select_return_val(self.NetworkedSettings[id])
        end

        if IsValid(ply) then
            if self.ClientSettings[ply:UserID()] then
                return select_return_val(self.ClientSettings[ply:UserID()][id])
            end
            return select_return_val(nil)
        end

        error("Networked setting " .. id .. " was requested for invalid player " .. tostring(ply))
    end

    error("Requested setting " .. "either doesn't exist or has no defined class")
    return
end

--------------------------------------------------------------------------------
-- Saving

local LOCAL_SETTINGS_FILE = "tardis_settings_cl.txt"
local NETWORKED_SETTINGS_FILE = "tardis_settings_cl_nw.txt"
local GLOBAL_SETTINGS_FILE = "tardis_settings_sv.txt"

function TARDIS:SaveSettings()

    local function SaveSettingsToFile(settings_table, settings_file)
        local settings={}
        for k,v in pairs(settings_table) do
            local data = self.SettingsData[k]
            if data and data.value ~= v then
                settings[k] = v
            end
        end
        file.Write(settings_file, self.von.serialize(settings))
    end

    if SERVER then
        SaveSettingsToFile(self.GlobalSettings, GLOBAL_SETTINGS_FILE)
    else
        SaveSettingsToFile(self.LocalSettings, LOCAL_SETTINGS_FILE)
        SaveSettingsToFile(self.NetworkedSettings, NETWORKED_SETTINGS_FILE)
    end
end

function TARDIS:LoadSettings()

    local function LoadSettingsFromFile(settings_table, settings_file)
        if file.Exists(settings_file, "DATA") then
            local file_contents = file.Read(settings_file, "DATA")
            local loaded_settings = self.von.deserialize(file_contents)

            table.Merge(settings_table, loaded_settings)
        end
    end

    if SERVER then
        LoadSettingsFromFile(self.GlobalSettings, GLOBAL_SETTINGS_FILE)
    else
        LoadSettingsFromFile(self.LocalSettings, LOCAL_SETTINGS_FILE)
        LoadSettingsFromFile(self.NetworkedSettings, NETWORKED_SETTINGS_FILE)
    end

    self:SaveSettings()
    self:SendSettings()
end

function TARDIS:ResetSettings()
    if SERVER then
        self.GlobalSettings={}
    else
        self.LocalSettings={}
        self.NetworkedSettings={}
    end
    self:SaveSettings()
    self:SendSettings()
end

function TARDIS:ResetSectionSettings(section)
    for k,v in pairs(self.SettingsData) do
        if (section ~= nil and v.section == section) or (section == nil and v.option ~= nil) then
            if SERVER then
                self.GlobalSettings[k] = nil
            else
                self.NetworkedSettings[k] = nil
                self.LocalSettings[k] = nil
            end
        end
    end
    self:SaveSettings()
    self:SendSettings()
end

--------------------------------------------------------------------------------
-- Networking

if SERVER then
    util.AddNetworkString("TARDIS-Settings")
    util.AddNetworkString("TARDIS-RequestSettings")
    util.AddNetworkString("TARDIS-ClientSettings")

    net.Receive("TARDIS-ClientSettings",function(len,ply)
        local userID = ply:UserID()
        if not TARDIS.ClientSettings[userID] then TARDIS.ClientSettings[userID]={} end
        local mode=net.ReadBool()
        if mode then
            local key=net.ReadType()
            local value=net.ReadType()
            TARDIS.ClientSettings[userID][key]=value
            net.Start("TARDIS-ClientSettings")
                net.WriteInt(userID,8)
                net.WriteBool(mode)
                net.WriteType(key)
                net.WriteType(value)
            net.Broadcast()
        else
            local str=net.ReadString()
            TARDIS.ClientSettings[userID]=TARDIS.von.deserialize(str)
            net.Start("TARDIS-ClientSettings")
                net.WriteInt(userID,8)
                net.WriteBool(mode)
                net.WriteString(str)
            net.Broadcast()
        end
    end)

    function TARDIS:RequestSettings(ply)
        net.Start("TARDIS-RequestSettings")
        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    function TARDIS:SendPlayerSettings(ply)
        for k,v in pairs(self.ClientSettings) do
            net.Start("TARDIS-ClientSettings")
                net.WriteInt(k,8)
                net.WriteBool(false)
                net.WriteString(self.von.serialize(v))
            if IsValid(ply) then
                net.Send(ply)
            else
                net.Broadcast()
            end
        end
    end

    hook.Add("PlayerInitialSpawn", "TARDIS-Settings", function(ply)
        TARDIS:SendSettings(ply)
        TARDIS:SendPlayerSettings(ply)
        TARDIS:RequestSettings(ply)
    end)
else
    net.Receive("TARDIS-RequestSettings",function(len)
        TARDIS:SendSettings()
    end)

    net.Receive("TARDIS-ClientSettings",function(len)
        local ply=net.ReadInt(8)
        if not TARDIS.ClientSettings[ply] then TARDIS.ClientSettings[ply]={} end
        local mode=net.ReadBool()
        if mode then
            TARDIS.ClientSettings[ply][net.ReadType()]=net.ReadType()
        else
            TARDIS.ClientSettings[ply]=TARDIS.von.deserialize(net.ReadString())
        end
    end)

    net.Receive("TARDIS-Settings",function(len)
        local mode=net.ReadBool()
        if mode then
            TARDIS.GlobalSettings[net.ReadType()]=net.ReadType()
        else
            table.Merge(TARDIS.GlobalSettings,TARDIS.von.deserialize(net.ReadString()))
        end
    end)
end

function TARDIS:SendSetting(id,value,ply)
    net.Start(SERVER and "TARDIS-Settings" or "TARDIS-ClientSettings")
        net.WriteBool(true)
        net.WriteType(id)
        net.WriteType(value)
    if SERVER then
        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end
end

function TARDIS:SendSettings(ply)
    net.Start(SERVER and "TARDIS-Settings" or "TARDIS-ClientSettings")
        net.WriteBool(false)
        net.WriteString(self.von.serialize(SERVER and self.GlobalSettings or self.NetworkedSettings))
    if SERVER then
        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end
end

TARDIS:LoadFolder("settings")
TARDIS:LoadSettings()
