-- Open door with E, go in with Alt-E


if SERVER then
	function ENT:ToggleDoor()
		if not IsValid(self.interior) then return end
		self:SetData("doorstate",not self:GetData("doorstate",false),true)
		self:CallHook("ToggleDoor", self:DoorOpen())
	end
	
	function ENT:DoorOpen()
		return self:GetData("doorstate",false)
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
		self:SetData("door", self.Door, true)
	end)
	
	ENT:AddHook("OnRemove", "doors", function(self)
		if IsValid(self.Door) then
			self.Door:Remove()
			self.Door=nil
		end
	end)
	
	local meta=FindMetaTable("Entity")
	meta.OldSetSkin=meta.OldSetSkin or meta.SetSkin
	function meta.SetSkin(...)
		meta.OldSetSkin(...)
		hook.Call("SkinChanged", self, ...)
	end
	
	hook.Add("SkinChanged", "tardis-door", function(ent,i)
		if ent.TardisExterior then
			local door=ent.Door
			if IsValid(door) then
				door:SetSkin(i)
			end
		end
	end)
else
	function ENT:DoorOpen()
		return self.DoorPos ~= 0
	end
	
	function ENT:DoorMoving()
		return self.DoorPos ~= self.DoorTarget
	end

	ENT:AddHook("Initialize", "doors", function(self)
		self.DoorPos=0
		self.DoorTarget=0
	end)
	
	ENT:AddHook("Think", "doors", function(self)
		self.DoorTarget=self.DoorOverride or (self:GetData("doorstate",false) and 1 or 0)
		
		-- Have to spam it otherwise it glitches out (http://facepunch.com/showthread.php?t=1414695)
		self.DoorPos=self.DoorOverride or math.Approach(self.DoorPos,self.DoorTarget,FrameTime()*2)
		
		local door=self:GetData("door")
		if IsValid(door) then
			door:SetPoseParameter("switch", self.DoorPos)
			door:InvalidateBoneCache()
		end
	end)
end
