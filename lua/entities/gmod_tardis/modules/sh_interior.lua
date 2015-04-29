-- Adds an interior

if SERVER then
	local function FindPosition(self)
		local td={}
		td.start=self:GetPos()+Vector(0,0,99999999)
		td.endpos=self:GetPos()
		td.mins=Vector(-1000,-1000,-1000)
		td.maxs=Vector(1000,1000,1000)
		td.filter={self}
		td.mask = MASK_NPCWORLDSTATIC
		
		local tr=util.TraceHull(td)
		if util.IsInWorld(tr.HitPos) then -- single trace worked
			return tr.HitPos
		else -- double trace needed
			td.start=tr.HitPos+Vector(0,0,-6000)
			td.endpos=tr.HitPos
			td.mask = nil
			tr=util.TraceHull(td)
			return tr.HitPos
		end
	end
	
	ENT:AddHook("Initialize", "interior", function(self)
		local pos=FindPosition(self,e)
		if not util.IsInWorld(pos) then
			self:GetCreator():ChatPrint("WARNING: TARDIS unable to locate space for interior, move to open space or use a different map.")
			return
		end
		
		local e=ents.Create("gmod_tardis_interior")
		e.exterior=self
		e:SetCreator(self:GetCreator())
		if CPPI then
			e:CPPISetOwner(self:GetCreator())
		end
		e:Spawn()
		e:Activate()
		e:SetPos(pos)
		self:DeleteOnRemove(e)
		e.occupants=self.occupants -- Hooray for referenced tables
		
		e:SetNetVar("exterior",self)
		self:SetNetVar("interior",e)
		self.interior=e
	end)
	
	ENT:AddHook("Use", "interior", function(self,a,c)
		if a:KeyDown(IN_WALK) or not IsValid(self.interior) then
			self:PlayerEnter(a)
		else
			self:ToggleDoor()
		end
	end)
	
	ENT:AddHook("OnRemove", "interior", function(self)
		for k,v in pairs(self.occupants) do
			self:PlayerExit(k,true)
		end
	end)
end