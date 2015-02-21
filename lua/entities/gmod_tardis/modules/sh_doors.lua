-- Open door with E, go in with Alt-E


if SERVER then
	function ENT:ToggleDoor()
		self:SetNetVar("doorstate",not self:GetNetVar("doorstate",false))
		self:CallHook("ToggleDoor", self:DoorOpen())
	end
	
	function ENT:DoorOpen()
		return self:GetNetVar("doorstate",false)
	end
	
	ENT:AddHook("ToggleDoor", "intdoors", function(self,open)
		local intdoor=self.interior:GetPart("door")
		if IsValid(intdoor) then
			if open then
				intdoor:SetCollisionGroup( COLLISION_GROUP_WORLD )
			else
				intdoor:SetCollisionGroup( COLLISION_GROUP_NONE )
			end
		end
	end)
	
	ENT:AddHook("Initialize", "doors", function(self)
		self.Door=ents.Create("prop_physics")
		self.Door:SetModel("models/drmatt/tardis/exterior/door.mdl")
		self.Door:SetPos(self:LocalToWorld(Vector(0,0,0)))
		self.Door:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		self.Door:SetParent(self)
		
		self.Door:SetBodygroup(1,1) -- Sticker
		self.Door:SetBodygroup(2,1) -- Lit sign
		self:SetNetVar("door", self.Door)
	end)
	
	ENT:AddHook("OnRemove", "doors", function(self)
		if IsValid(self.Door) then
			self.Door:Remove()
			self.Door=nil
		end
	end)
else
	function ENT:DoorOpen()
		return self.DoorPos ~= 0
	end

	ENT:AddHook("Initialize", "doors", function(self)
		self.DoorPos=0
		self.DoorTarget=0
	end)
	
	ENT:AddHook("Think", "doors", function(self)
		self.DoorTarget=self.DoorOverride or (self:GetNetVar("doorstate") and 1 or 0)
		
		-- Have to spam it otherwise it glitches out (http://facepunch.com/showthread.php?t=1414695)
		self.DoorPos=self.DoorOverride or math.Approach(self.DoorPos,self.DoorTarget,FrameTime()*2)
		
		local door=self:GetNetEnt("door")
		if IsValid(door) then
			door:SetPoseParameter("switch", self.DoorPos)
			door:InvalidateBoneCache()
		end
	end)
end
