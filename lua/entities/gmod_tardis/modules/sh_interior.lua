-- Adds an interior

if SERVER then
	local function FindPosition(self,e)
		local td={}
		td.start=self:GetPos()+Vector(0,0,99999999)
		td.endpos=self:GetPos()
		td.mins=e:OBBMins()
		td.maxs=e:OBBMaxs()
		td.filter={self,e}
		td.mask = MASK_NPCWORLDSTATIC
		
		local tr=util.TraceHull(td)
		td.start=tr.HitPos+Vector(0,0,-6000)
		td.endpos=tr.HitPos
		td.mask = nil
		tr=util.TraceHull(td)
		return tr.HitPos
	end
	
	ENT:AddHook("Initialize", "interior", function(self)
		local e=ents.Create("gmod_tardis_interior")
		e.exterior=self
		e.owner=self.owner
		if CPPI then
			e:CPPISetOwner(self.owner)
		end
		e:Spawn()
		e:Activate()
		e:SetPos(FindPosition(self,e))
		self:DeleteOnRemove(e)
		e.occupants=self.occupants -- Hooray for referenced tables
		
		e:SetNetVar("exterior",self)
		self:SetNetVar("interior",e)
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