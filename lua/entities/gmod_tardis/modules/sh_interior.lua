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

	function ENT:ToggleDoor()
		self:SetNetVar("doorstate",not self:GetNetVar("doorstate",false))
	end
	
	ENT:AddHook("Initialize", "interior", function(self)
		local e=ents.Create("gmod_tardis_interior")
		e.exterior=self
		e:SetNetVar("exterior",self)
		e:Spawn()
		e:Activate()
		e:SetPos(FindPosition(self,e))
		self:DeleteOnRemove(e)
		self.interior=e
		self.interior.occupants=self.occupants -- Hooray for referenced tables
		
		self:SetNetVar("doorstate",false)
	end)
	
	ENT:AddHook("Use", "interior", function(self,a,c)
		if a:KeyDown(IN_WALK) then
			self:ToggleDoor()
		else
			self:PlayerEnter(a)
		end
	end)
	
	ENT:AddHook("OnRemove", "interior", function(self)
		for k,v in pairs(self.occupants) do
			self:PlayerExit(v,true)
		end
	end)
	
elseif CLIENT then
	ENT:AddHook("Initialize", "interior", function(self)
		self.DoorPos=0
	end)
	
	ENT:AddHook("Think", "interior", function(self)
		local target=0
		if self:GetNetVar("doorstate") then
			target=1
		end
		
		-- Have to spam it otherwise it glitches out (http://facepunch.com/showthread.php?t=1414695)
		self.DoorPos=math.Approach(self.DoorPos,target,FrameTime()*2)
		self:SetPoseParameter("switch", self.DoorPos)
		self:InvalidateBoneCache()
	end)
end