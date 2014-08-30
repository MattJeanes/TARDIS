-- Opens door with Alt-E, go in with E


if SERVER then
	function ENT:ToggleDoor()
		self:SetNetVar("doorstate",not self:GetNetVar("doorstate",false))
		self:CallHook("ToggleDoor", self:DoorOpen())
	end
	
	function ENT:DoorOpen()
		return self:GetNetVar("doorstate",false)
	end
	
	ENT:AddHook("ToggleDoor", "doors", function(self,open)
		if open then
			self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		else
			self:SetCollisionGroup( COLLISION_GROUP_NONE )
		end
	end)
else
	function ENT:DoorOpen()
		return self.DoorPos ~= 0 and true or false
	end

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
