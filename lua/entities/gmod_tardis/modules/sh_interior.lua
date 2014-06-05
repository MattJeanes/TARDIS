-- Adds an interior

if SERVER then
	local function FindPosition(self,e)
		local tracedata = {}
		tracedata.start=self:GetPos()
		tracedata.endpos=tracedata.start+(self:GetUp()*9999999)
		tracedata.mins=e:OBBMins()
		tracedata.maxs=e:OBBMaxs()
		tracedata.filter={self,e}
		tracedata.mask = MASK_NPCWORLDSTATIC
		local traceres=util.TraceHull(tracedata)
		if double then --TODO: Implement double
			tracedata.start=traceres.HitPos
			tracedata.endpos=tracedata.start+(self:GetUp()*-6000)
			traceres=util.TraceHull(tracedata)
			tracedata.start=self:GetPos()
			tracedata.endpos=tracedata.start+(self:GetUp()*9999999)
			traceres=util.TraceHull(tracedata)
		end
		return traceres.HitPos
	end
	
	function ENT:PlayerEnter(ply)
		if self.interior and IsValid(self.interior) then
			for k,v in pairs(self.occupants) do
				if ply==v then
					return --TODO: Handle properly
				end
			end
			table.insert(self.occupants,ply)
			ply:SetNWEntity("tardis",self)
			local pos=self:WorldToLocal(ply:GetPos())
			ply:SetPos(self.interior:LocalToWorld(Vector(0,-300,90))+Vector(0,pos.y,pos.z))
			local ang=(ply:EyeAngles()-self:GetAngles())+self.interior:GetAngles()+Angle(0,-90,0)
			local fwd=(ply:GetVelocity():Angle()+(self.interior:GetAngles()-self:GetAngles())+Angle(0,-90,0)):Forward()
			ply:SetEyeAngles(Angle(ang.p,ang.y,0))
			ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
		else
			--TODO: Go straight to 3rd person view bypassing interior if it doesnt exist for some reason
		end
	end
	
	function ENT:PlayerExit(ply,forced)
		if ply:InVehicle() then ply:ExitVehicle() end
		for k,v in pairs(self.occupants) do
			if ply==v then
				self.occupants[k]=nil
			end
		end
		ply:SetNWEntity("tardis",NULL)
		local pos=self:GetPos()+self:GetForward()*70+Vector(0,0,5)
		ply:SetPos(pos)
		if not forced then
			local ang=(ply:EyeAngles()-self.interior:GetAngles())+self:GetAngles()+Angle(0,90,0)
			local fwd=(ply:GetVelocity():Angle()+(self:GetAngles()-self.interior:GetAngles())+Angle(0,90,0)):Forward()
			ply:SetEyeAngles(Angle(ang.p,ang.y,0))
			ply:SetLocalVelocity(fwd*ply:GetVelocity():Length())
		end
	end

	ENT:AddHook("Initialize", "interior", function(self)
		local e=ents.Create("gmod_tardis_interior")
		e.exterior=self
		e:Spawn()
		e:Activate()
		e:SetPos(FindPosition(self,e))
		self:DeleteOnRemove(e)
		self.interior=e
	end)
	
	ENT:AddHook("Use", "interior", function(self,a,c)
		self:PlayerEnter(a)
	end)
	
	ENT:AddHook("OnRemove", "interior", function(self)
		for k,v in pairs(self.occupants) do
			self:PlayerExit(v,true)
		end
	end)
	
	ENT:AddHook("Think", "interior", function(self)
		if self.interior and IsValid(self.interior) then
			self.interior.occupants=self.occupants
		end
	end)
end