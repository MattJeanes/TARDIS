-- Settings

ENT.DefaultSettings = {} -- Lets us reset all settings
if SERVER then
	util.AddNetworkString("TARDIS-Settings")
	util.AddNetworkString("TARDIS-RequestSettings")
	util.AddNetworkString("TARDIS-ClientSettings")
	ENT.Settings = {}
	ENT.ClientSettings = {}
	
	net.Receive("TARDIS-ClientSettings",function(len,ply)
		if not TARDIS.ClientSettings[ply] then TARDIS.ClientSettings[ply]={} end
		local mode=net.ReadBool()
		if mode then
			local key=net.ReadType()
			local value=net.ReadType()
			TARDIS.ClientSettings[ply][key]=value
			net.Start("TARDIS-ClientSettings")
				net.WriteEntity(ply)
				net.WriteBool(mode)
				net.WriteType(key)
				net.WriteType(value)
			net.Broadcast()
		else
			local str=net.ReadString()
			TARDIS.ClientSettings[ply]=TARDIS.von.deserialize(str)
			net.Start("TARDIS-ClientSettings")
				net.WriteEntity(ply)
				net.WriteBool(mode)
				net.WriteString(str)
			net.Broadcast()
		end
	end)
else
	ENT.Settings = ENT.Settings or {}
	ENT.ClientSettings = {}
	ENT.LocalSettings = {}
	ENT.NetworkedSettings = {}
	ENT.DefaultNetworkedSettings = {}
	
	net.Receive("TARDIS-RequestSettings",function(len)
		TARDIS:SendSettings()
	end)
	
	net.Receive("TARDIS-ClientSettings",function(len)
		local ply=net.ReadEntity()
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

function ENT:AddSetting(name,value,networked)
	(networked and self.DefaultNetworkedSettings or self.DefaultSettings)[name]=value
	if (self.Settings[name] ~= nil) or (self.ClientSettings[name] ~= nil) or (CLIENT and ((self.NetworkedSettings[name] ~= nil) or (self.LocalSettings[name] ~= nil))) then return end
	self:SetSetting(name,value,networked,true)
end

function ENT:SetSetting(name,value,networked,broadcast)
	if SERVER then
		self.Settings[name]=value
	elseif networked then
		self.NetworkedSettings[name]=value
	else
		self.LocalSettings[name]=value
	end
	self:SaveSettings()
	if (SERVER and broadcast) or networked then
		self:SendSetting(name,value)
	end
	self:CallHook("SettingChanged", name, value)
	TARDISI:CallHook("SettingChanged", name, value)
end

function ENT:GetSetting(name,default,ply)
	if ply and self.ClientSettings[ply] and (self.ClientSettings[ply][name]~=nil) then
		return self.ClientSettings[ply][name]
	elseif self.Settings[name] ~= nil then
		return self.Settings[name]
	elseif CLIENT and (self.LocalSettings[name] ~= nil) then
		return self.LocalSettings[name]
	elseif CLIENT and ply and (self.NetworkedSettings[name]~=nil) then
		return self.NetworkedSettings[name]
	else
		return default
	end
end

function ENT:SendSetting(name,value,ply)
	net.Start(SERVER and "TARDIS-Settings" or "TARDIS-ClientSettings")
		net.WriteBool(true)
		net.WriteType(name)
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

function ENT:SendSettings(ply)
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

if SERVER then
	function ENT:RequestSettings(ply)
		net.Start("TARDIS-RequestSettings")
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
	
	function ENT:SendPlayerSettings(ply)
		for k,v in pairs(self.ClientSettings) do
			net.Start("TARDIS-ClientSettings")
				net.WriteEntity(k)
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
end

local filename="tardis_settings_"..(SERVER and "sv" or "cl")..".txt"
local filenamenw="tardis_settings_cl_nw.txt"

function ENT:SaveSettings()
	file.Write(filename, self.von.serialize(CLIENT and self.LocalSettings or self.Settings))
	if CLIENT then
		file.Write(filenamenw, self.von.serialize(self.NetworkedSettings))
	end
end

function ENT:LoadSettings()
	if file.Exists(filename, "DATA") then
		table.Merge(CLIENT and self.LocalSettings or self.Settings, self.von.deserialize(file.Read(filename, "DATA")))
	end
	if CLIENT and file.Exists(filenamenw, "DATA") then
		table.Merge(self.NetworkedSettings, self.von.deserialize(file.Read(filenamenw, "DATA")))
	end
	self:SaveSettings()
	self:SendSettings()
end
ENT:LoadSettings()

function ENT:ResetSettings()
	if SERVER then
		self.Settings={}
		for k,v in pairs(self.DefaultSettings) do
			self.Settings[k]=v
		end
	else
		self.LocalSettings={}
		for k,v in pairs(self.DefaultSettings) do
			self.LocalSettings[k]=v
		end
		self.NetworkedSettings={}
		for k,v in pairs(self.DefaultNetworkedSettings) do
			self.NetworkedSettings[k]=v
		end
	end
	self:SaveSettings()
	self:SendSettings()
end