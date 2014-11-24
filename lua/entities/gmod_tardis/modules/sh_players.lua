// Handles players

if SERVER then
	function ENT:PlayerEnter(ply,notp)
		if self.interior and IsValid(self.interior) then
			for k,v in pairs(self.occupants) do
				if ply==v then
					return --TODO: Handle properly
				end
			end
			if IsValid(ply:GetNetEnt("tardis")) then
				ply:GetNetEnt("tardis"):PlayerExit(ply,true,true)
			end
			table.insert(self.occupants,ply)
			ply:SetNetVar("tardis",self)
			ply:SetNetVar("tardis_i",self.interior)
			if not notp then
				local pos=self:WorldToLocal(ply:GetPos())
				ply:SetPos(self.interior:LocalToWorld(Vector(0,-300,95))+Vector(0,pos.y,pos.z))
				local ang=(ply:EyeAngles()-self:GetAngles())+self.interior:GetAngles()+Angle(0,-90,0)
				local fwd=(ply:GetVelocity():Angle()+(self.interior:GetAngles()-self:GetAngles())+Angle(0,-90,0)):Forward()
				ply:SetEyeAngles(Angle(ang.p,ang.y,0))
				ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
			end
		end
	end

	function ENT:PlayerExit(ply,forced,notp)
		if ply:InVehicle() then ply:ExitVehicle() end
		for k,v in pairs(self.occupants) do
			if ply==v then
				self.occupants[k]=nil
			end
		end
		ply:SetNetVar("tardis",nil)
		ply:SetNetVar("tardis_i",nil)
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
	end
end