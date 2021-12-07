-- Open door with E, go in with Alt-E

if SERVER then
	local function runcallbacks(callbacks,state)
		for k,v in pairs(callbacks) do
			k(state)
			callbacks[k]=nil
		end
	end

	local function delay(callback,state) -- Ensures callback is always called async
		timer.Simple(0,function()
			callback(state)
		end)
	end

	function ENT:ToggleDoor(callback)
		if not IsValid(self.interior) then return false end
		if not self:GetData("doorchangecallback",false) then
			self:SetData("doorchangecallback",{})
		end
		local callbacks=self:GetData("doorchangecallback")
		local doorstate=self:GetData("doorstatereal",false)
		if self:CallHook("CanToggleDoor", doorstate)==false then
			if callback then
				callback(doorstate)
			end
			runcallbacks(callbacks,doorstate)
			return false
		end
		doorstate=not doorstate

		self:SetData("doorstatereal",doorstate,true)
		self:SetData("doorchangewait",not doorstate)

		self:CallHook("ToggleDoorReal",doorstate)

		if doorstate then
			self:SetData("doorstate",true,true)
			self:SetData("doorchange",CurTime())
			self:CallHook("ToggleDoor",true)
			if callback then
				delay(callback,true)
			end
			runcallbacks(callbacks,true)
		else
			if callback then
				callbacks[callback]=true
			end
			local dooranimtime = self.metadata.Exterior.DoorAnimationTime
			if self.metadata.EnableClassicDoors == true then
				dooranimtime = math.max(dooranimtime, self.metadata.Interior.IntDoorAnimationTime)
			end
			self:SetData("doorchange",CurTime() + dooranimtime)
		end
		return true
	end

	function ENT:OpenDoor(callback)
		if self:GetData("doorstate",false) then
			delay(callback,true)
		else
			self:ToggleDoor(callback)
		end
	end

	function ENT:CloseDoor(callback)
		if self:GetData("doorstate",false) ~= self:GetData("doorstatereal",false) then
			local callbacks=self:GetData("doorchangecallback")
			callbacks[callback]=true
		elseif not self:GetData("doorstate",false) then
			delay(callback,false)
		else
			self:ToggleDoor(callback)
		end
	end

	function ENT:DoorOpen(real)
		if real then
			return self:GetData("doorstatereal",false)
		else
			return self:GetData("doorstate",false)
		end
	end

	ENT:AddHook("Initialize", "doors", function(self)
		self:SetBodygroup(1,1)
	end)

	ENT:AddHook("ToggleDoor", "intdoors", function(self,open)
		local intdoor=TARDIS:GetPart(self.interior,"door")
		if IsValid(intdoor) then
			local override = self:CallHook("DoorCollisionOverride")
			if (override == nil and open) or override==false then
				intdoor:SetCollisionGroup( COLLISION_GROUP_WORLD )
			elseif override or override==nil then
				intdoor:SetCollisionGroup( COLLISION_GROUP_NONE )
			end
		end
	end)

	ENT:AddHook("ToggleDoor", "extcollision",function(self,open)
		local door = TARDIS:GetPart(self,"door")
		if IsValid(door) then
			local override = self:CallHook("DoorCollisionOverride")
			if (override == nil and open) or override==false then
				door:SetSolid(SOLID_NONE)
			elseif override or override==nil then
				door:SetSolid(SOLID_VPHYSICS)
			end
		end
	end)

	ENT:AddHook("ShouldExteriorDoorCollide", "dooropen", function(self,open)
		local override = self:CallHook("DoorCollisionOverride")
		if (override == nil and open) or override==false then
			return false
		elseif override or override==nil then
			return true
		end
	end)

	ENT:AddHook("ToggleDoorReal", "doors", function(self,open)
		self:SendMessage("ToggleDoorReal",function()
			net.WriteBool(open)
		end)
	end)

	ENT:AddHook("Think", "doors", function(self)
		if self:GetData("doorchangewait",false) and CurTime()>self:GetData("doorchange",0) then
			self:SetData("doorchangewait",nil)
			self:SetData("doorstate",false,true)
			self:CallHook("ToggleDoor",false)
			local callbacks=self:GetData("doorchangecallback")
			runcallbacks(callbacks,false)
			self:SetData("doorchangecallback",nil)
		end
		local door = TARDIS:GetPart(self,"door")
		if IsValid(door) then
			if self:CallHook("ShouldExteriorDoorCollide",self:GetData("doorstatereal",false)) then
				door:SetSolid(SOLID_VPHYSICS)
			else
				door:SetSolid(SOLID_NONE)
			end
		end
	end)

	ENT:AddHook("ShouldThinkFast","doors",function(self)
		if self:GetData("doorchangewait") then
			return true
		end
	end)

	ENT:AddHook("SkinChanged","doors",function(self,i)
		local door=TARDIS:GetPart(self,"door")
		local intdoor=TARDIS:GetPart(self.interior,"door")
		if IsValid(door) then
			door:SetSkin(i)
		end
		if IsValid(intdoor) then
			intdoor:SetSkin(i)
		end
	end)

	ENT:AddHook("BodygroupChanged","doors",function(self,bodygroup,value)
		local door=TARDIS:GetPart(self,"door")
		local intdoor=TARDIS:GetPart(self.interior,"door")
		if IsValid(door) then
			door:SetBodygroup(bodygroup,value)
		end
		if IsValid(intdoor) then
			intdoor:SetBodygroup(bodygroup,value)
		end
	end)
else
	TARDIS:AddSetting({
		id="doorsounds-enabled",
		name="Door Sound",
		desc="Whether a sound is made when toggling the door or not",
		section="Sounds",
		value=true,
		type="bool",
		option=true
	})

	function ENT:DoorOpen(real)
		local door=self:GetPart("door")
		if real and IsValid(door) then
			return door.DoorPos ~= 0
		else
			return self:GetData("doorstate",false)
		end
	end

	function ENT:DoorMoving()
		local door=self:GetPart("door")
		if IsValid(door) then
			return door.DoorPos ~= door.DoorTarget
		else
			return false
		end
	end

	ENT:OnMessage("ToggleDoorReal",function(self)
		self:CallHook("ToggleDoorReal",net.ReadBool())
	end)

	ENT:AddHook("ToggleDoorReal","doorsounds",function(self,open)
		local extsnds = self.metadata.Exterior.Sounds.Door
		local intsnds = self.metadata.Interior.Sounds.Door or extsnds

		if TARDIS:GetSetting("doorsounds-enabled") and TARDIS:GetSetting("sound") then
			if extsnds.enabled then
				local extpart = self:GetPart("door")
				local extsnd = open and extsnds.open or extsnds.close
				if IsValid(extpart) and extpart.exterior:CallHook("ShouldEmitDoorSound")~=false then
					extpart:EmitSound(extsnd)
				end
			end
			if intsnds.enabled and IsValid(self.interior) then
				local intpart = self.interior:GetPart("door")
				local intsnd = open and intsnds.open or intsnds.close
				if IsValid(intpart) then
					intpart:EmitSound(intsnd)
				end
			end
		end
	end)
end
