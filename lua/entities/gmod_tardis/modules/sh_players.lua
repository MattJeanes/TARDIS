-- Handles players

if SERVER then
	util.AddNetworkString("TARDIS-PlayerData")
	util.AddNetworkString("TARDIS-PlayerDataClear")
	util.AddNetworkString("TARDIS-EnterExit")
	
	function ENT:PlayerEnter(ply,notp)
		if ply.tardis_cooldowncur and ply.tardis_cooldowncur>CurTime() then return end
		if self.occupants[ply] then
			return --TODO: Handle properly
		end
		if IsValid(ply:GetTardisData("exterior")) and ply:GetTardisData("exterior")~=self then
			ply:GetTardisData("exterior"):PlayerExit(ply,true,true)
		end
		self.occupants[ply]=true
		ply:SetTardisData("exterior", self, true)
		ply:SetTardisData("interior", self.interior, true)
		net.Start("TARDIS-EnterExit")
			net.WriteBool(true)
			net.WriteEntity(self)
			net.WriteEntity(self.interior)
		net.Send(ply)
		if IsValid(self.interior) then
			local fallback=self.interior.interior.Fallback
			if (not notp) and fallback then
				local pos=self:WorldToLocal(ply:GetPos())
				ply:SetPos(self.interior:LocalToWorld(fallback.pos))
				local ang=self.interior:LocalToWorldAngles(self:WorldToLocalAngles(ply:EyeAngles())+fallback.ang)
				local fwd=(self.interior:LocalToWorldAngles(self:WorldToLocalAngles(ply:GetVelocity():Angle())+fallback.ang)):Forward()
				ply:SetEyeAngles(Angle(ang.p,ang.y,0))
				ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
			end
		else
			ply:Spectate(OBS_MODE_ROAMING)
			self:PlayerThirdPerson(ply,true)
		end
		self:CallHook("PlayerEnter", ply, notp)
		if IsValid(self.interior) then
			self.interior:CallHook("PlayerEnter", ply, notp)
		end
	end

	function ENT:PlayerExit(ply,forced,notp)
		self:CallHook("PlayerExit", ply, forced, notp)
		if IsValid(self.interior) then
			self.interior:CallHook("PlayerExit", ply, forced, notp)
		end
		if not IsValid(self.interior) then
			-- spectator mode doesn't exit properly without respawning
			local pos,ang=ply:GetPos(),ply:EyeAngles()
			local hp,armor=ply:Health(),ply:Armor()
			local weps={}
			local ammo={}
			for k,v in pairs(ply:GetWeapons()) do
				table.insert(weps, v:GetClass())
				local p=v:GetPrimaryAmmoType()
				local s=v:GetSecondaryAmmoType()
				if p != -1 then
					ammo[p]=ply:GetAmmoCount(p)
				end
				if s != -1 then
					ammo[s]=ply:GetAmmoCount(s)
				end
			end
			--[[ restoring active wep doesn't work clientside properly
			local activewep
			if IsValid(ply:GetActiveWeapon()) then
				activewep=ply:GetActiveWeapon():GetClass()
			end
			]]--
			
			ply:Spawn()
			
			ply:SetPos(pos)
			ply:SetEyeAngles(ang)
			ply:SetHealth(hp)
			ply:SetArmor(armor)
			for k,v in pairs(weps) do
				ply:Give(tostring(v))
			end
			for k,v in pairs(ammo) do
				ply:SetAmmo(v,k)
			end
			ply.tardis_cooldowncur=CurTime()+1
		end
		if ply:InVehicle() then ply:ExitVehicle() end
		self.occupants[ply]=nil
		ply:ClearTardisData()
		net.Start("TARDIS-EnterExit")
			net.WriteBool(false)
			net.WriteEntity(self)
			net.WriteEntity(self.interior)
		net.Send(ply)
		if not notp then
			local pos=self:LocalToWorld(Vector(60,0,5))
			ply:SetPos(pos)
			if IsValid(self.interior) then
				local fallback=self.interior.interior.Fallback
				if (not forced) and fallback then
					local ang=self:LocalToWorldAngles(self.interior:WorldToLocalAngles(ply:EyeAngles())-fallback.ang)
					local fwd=(self:LocalToWorldAngles(self.interior:WorldToLocalAngles(ply:GetVelocity():Angle())-fallback.ang)):Forward()
					ply:SetEyeAngles(Angle(ang.p,ang.y,0))
					ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
				end
			end
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
		local ext=net.ReadEntity()
		local int=net.ReadEntity()
		
		if not IsValid(ext) then return end
		if enter then
			ext:CallHook("PlayerEnter")
		else
			ext:CallHook("PlayerExit")
		end
		
		if not IsValid(int) then return end
		if enter then
			int:CallHook("PlayerEnter")
		else
			int:CallHook("PlayerExit")
		end
	end)
end