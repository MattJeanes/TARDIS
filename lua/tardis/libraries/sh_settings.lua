-- Settings

TARDIS.SettingsData = TARDIS.SettingsData or {}
TARDIS.Settings = TARDIS.Settings or {}
TARDIS.ClientSettings = TARDIS.ClientSettings or {}

if CLIENT then
    TARDIS.LocalSettings = TARDIS.LocalSettings or {}
    TARDIS.NetworkedSettings = TARDIS.NetworkedSettings or {}
end

--------------------------------------------------------------------------------
-- Setup

function TARDIS:AddSetting(data)
    self.SettingsData[data.id]=data

    if self.Settings[data.id] ~= nil then return end
    if self.ClientSettings[data.id] ~= nil then return end
    if CLIENT and (self.NetworkedSettings[data.id] ~= nil) then return end
    if CLIENT and (self.LocalSettings[data.id] ~= nil) then return end

    self:SetSetting(data.id,data.value,data.networked,true)
end

function TARDIS:GetSettingData(id)
    return self.SettingsData[id]
end

function TARDIS:GetSettingsData()
    return self.SettingsData
end

--------------------------------------------------------------------------------
-- Accessing

function TARDIS:SetSetting(id,value,networked,broadcast)
    if self.SettingsData[id] and self.SettingsData[id].type == "integer" then
        value = math.Round(value)
    end

    if SERVER then
        self.Settings[id]=value
    elseif networked then
        self.NetworkedSettings[id]=value
    else
        self.LocalSettings[id]=value
    end
    self:SaveSettings()
    if (SERVER and broadcast) or networked then
        self:SendSetting(id,value)
    end
end

function TARDIS:GetSetting(id,default,ply)
    if ply and IsValid(ply) and self.ClientSettings[ply:UserID()] and (self.ClientSettings[ply:UserID()][id]~=nil) then
        return self.ClientSettings[ply:UserID()][id]
    elseif self.Settings[id] ~= nil then
        return self.Settings[id]
    elseif CLIENT and (self.LocalSettings[id] ~= nil) then
        return self.LocalSettings[id]
    elseif CLIENT and (self.NetworkedSettings[id]~=nil) then
        return self.NetworkedSettings[id]
    else
        return default
    end
end

--------------------------------------------------------------------------------
-- Saving

local filename="tardis_settings_"..(SERVER and "sv" or "cl")..".txt"
local filenamenw="tardis_settings_cl_nw.txt"

function TARDIS:SaveSettings()
    local settings={}
    for k,v in pairs(CLIENT and self.LocalSettings or self.Settings) do
        if self:GetSettingData(k) and self:GetSettingData(k).value~=v then
            settings[k]=v
        end
    end
    file.Write(filename, self.von.serialize(settings))
    if CLIENT then
        local settings={}
        for k,v in pairs(self.NetworkedSettings) do
            if self:GetSettingData(k) and self:GetSettingData(k).value~=v then
                settings[k]=v
            end
        end
        file.Write(filenamenw, self.von.serialize(settings))
    end
end

function TARDIS:LoadSettings()
    if file.Exists(filename, "DATA") then
        table.Merge(CLIENT and self.LocalSettings or self.Settings, self.von.deserialize(file.Read(filename, "DATA")))
    end
    if CLIENT and file.Exists(filenamenw, "DATA") then
        table.Merge(self.NetworkedSettings, self.von.deserialize(file.Read(filenamenw, "DATA")))
    end
    self:SaveSettings()
    self:SendSettings()
end

function TARDIS:ResetSettings()
    if SERVER then
        self.Settings={}
        for k,v in pairs(self.SettingsData) do
            self.Settings[k]=v.value
        end
    else
        self.LocalSettings={}
        self.NetworkedSettings={}
        for k,v in pairs(self.SettingsData) do
            (v.networked and self.NetworkedSettings or self.LocalSettings)[k]=v.value
        end
    end
    self:SaveSettings()
    self:SendSettings()
end

function TARDIS:ResetSectionSettings(section)
    if SERVER then
        for k,v in pairs(self.SettingsData) do
            if (section ~= nil and v.section == section) or (section == nil and v.option ~= nil) then
                self.Settings[k] = v.value
            end
        end
    else
        for k,v in pairs(self.SettingsData) do
            if (section ~= nil and v.section == section) or (section == nil and v.option ~= nil) then
                self.NetworkedSettings[k] = nil
                self.LocalSettings[k] = nil
                (v.networked and self.NetworkedSettings or self.LocalSettings)[k]=v.value
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
            TARDIS.Settings[net.ReadType()]=net.ReadType()
        else
            table.Merge(TARDIS.Settings,TARDIS.von.deserialize(net.ReadString()))
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
        net.WriteString(self.von.serialize(SERVER and self.Settings or self.NetworkedSettings))
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

TARDIS:LoadSettings()
TARDIS:LoadFolder("settings")
