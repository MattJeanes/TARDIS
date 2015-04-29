// Handles players

if SERVER then
	util.AddNetworkString("TARDIS-PlayerData")
	util.AddNetworkString("TARDIS-PlayerDataClear")
	util.AddNetworkString("TARDIS-EnterExit")
	
	function ENT:PlayerEnter(ply,notp)
		if self.interior and IsValid(self.interior) then
			if self.occupants[ply] then
				return --TODO: Handle properly
			end
			if IsValid(ply:GetNetEnt("tardis")) then
				ply:GetNetEnt("tardis"):PlayerExit(ply,true,true)
			end
			self.occupants[ply]=true
			ply:SetTardisData("exterior", self, true)
			ply:SetTardisData("interior", self.interior, true)
			ply:SetNetVar("tardis",self)
			ply:SetNetVar("tardis_i",self.interior)
			net.Start("TARDIS-EnterExit")
				net.WriteBool(true)
				net.WriteEntity(ply)
				net.WriteEntity(self)
				net.WriteEntity(self.interior)
			net.Broadcast()
			if not notp then
				local pos=self:WorldToLocal(ply:GetPos())
				ply:SetPos(self.interior:LocalToWorld(Vector(0,-300,95))+Vector(0,pos.y,pos.z))
				local ang=(ply:EyeAngles()-self:GetAngles())+self.interior:GetAngles()+Angle(0,-90,0)
				local fwd=(ply:GetVelocity():Angle()+(self.interior:GetAngles()-self:GetAngles())+Angle(0,-90,0)):Forward()
				ply:SetEyeAngles(Angle(ang.p,ang.y,0))
				ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
			end
		else
			ply:ChatPrint("WARNING: Missing interior fallback not yet implemented.")
		end
		self:CallHook("PlayerEnter", ply, notp)
		self.interior:CallHook("PlayerEnter", ply, notp)
	end

	function ENT:PlayerExit(ply,forced,notp)
		if ply:InVehicle() then ply:ExitVehicle() end
		self.occupants[ply]=nil
		ply:ClearTardisData()
		ply:SetNetVar("tardis",nil)
		ply:SetNetVar("tardis_i",nil)
		net.Start("TARDIS-EnterExit")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.WriteEntity(self)
			net.WriteEntity(self.interior)
		net.Broadcast()
		if not notp then
			local pos=self:GetPos()+self:GetForward()*70+Vector(0,0,5)
			ply:SetPos(pos)
			if not forced then
				local ang=(ply:EyeAngles()-self.interior:GetAngles())+self:GetAngles()+Angle(0,90,0)
				local fwd=(ply:GetVelocity():Angle()+(self:GetAngles()-self.interior:GetAngles())+Angle(0,90,0)):Forward()
				ply:SetEyeAngles(Angle(ang.p,ang.y,0))
				ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
			end
		end
		self:CallHook("PlayerExit", ply, forced, notp)
		self.interior:CallHook("PlayerExit", ply, forced, notp)
		
		if not IsValid(int) then return end
		if enter then
			int:CallHook("PlayerEnter")
		else
			int:CallHook("PlayerExit")
		end
	end
	
	local meta=FindMetaTable("Player")
	function meta:SetTardisData(k,v,network)
		if not self.tardis then self.tardis = {} end
		self.tardis[k]=v
		
		if network then
			net.Start("TARDIS-PlayerData")
				net.WriteType(k)
				net.WriteType(v)
			net.Send(self)
		end
	end
	
	function meta:GetTardisData(k,default)
		return (self.tardis and self.tardis[k]~=nil) and self.tardis[k] or default
	end
	
	function meta:ClearTardisData()
		self.tardis=nil
		net.Start("TARDIS-PlayerDataClear")
		net.Send(self)
	end
else
	local meta=FindMetaTable("Player")
	function meta:SetTardisData(k,v)		
		if not self.tardis then self.tardis = {} end
		self.tardis[k]=v
	end
	
	function meta:GetTardisData(k,default)
		return (self.tardis and self.tardis[k]~=nil) and self.tardis[k] or default
	end
	
	function meta:ClearTardisData()
		self.tardis=nil
	end
	
	net.Receive("TARDIS-PlayerData", function()
		local k=net.ReadType(net.ReadUInt(8))
		local v=net.ReadType(net.ReadUInt(8))
		LocalPlayer():SetTardisData(k,v)
	end)
	
	net.Receive("TARDIS-PlayerDataClear", function()
		LocalPlayer():ClearTardisData()
	end)
	
	net.Receive("TARDIS-EnterExit", function()
		local enter=net.ReadBool()
		local ply=net.ReadEntity()
		local ext=net.ReadEntity()
		local int=net.ReadEntity()
		
		if not IsValid(ext) then return end
		if enter then
			ext:CallHook("PlayerEnter",ply)
		else
			ext:CallHook("PlayerExit",ply)
		end
		
		if not IsValid(int) then return end
		if enter then
			int:CallHook("PlayerEnter",ply)
		else
			int:CallHook("PlayerExit",ply)
		end
	end)
end