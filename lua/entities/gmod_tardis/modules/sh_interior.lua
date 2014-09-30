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
	
	ENT:AddHook("Initialize", "interior", function(self)
		local e=ents.Create("gmod_tardis_interior")
		e.exterior=self
		
		e:Spawn()
		e:Activate()
		e:SetPos(FindPosition(self,e))
		self:DeleteOnRemove(e)
		e.occupants=self.occupants -- Hooray for referenced tables
		e.owner=self.owner
		if CPPI then
			e:CPPISetOwner(self.owner)
		end
		e:SetNetVar("exterior",self:EntIndex())
		self:SetNetVar("interior",e:EntIndex())
		self.interior=e
	end)
	
	ENT:AddHook("Use", "interior", function(self,a,c)
		if a:KeyDown(IN_WALK) then
			self:PlayerEnter(a)
		else
			self:ToggleDoor()
		end
	end)
	
	ENT:AddHook("OnRemove", "interior", function(self)
		for k,v in pairs(self.occupants) do
			self:PlayerExit(v,true)
		end
	end)
end