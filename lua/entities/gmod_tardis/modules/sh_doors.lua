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
		if not IsValid(self.interior) then return end
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
			return
		end
		doorstate=not doorstate
		
		self:SetData("doorstatereal",doorstate,true)
		self:SetData("doorchangewait",not doorstate)
		
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
			self:SetData("doorchange",CurTime()+0.5)
		end
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
			if open then
				intdoor:SetCollisionGroup( COLLISION_GROUP_WORLD )
			else
				intdoor:SetCollisionGroup( COLLISION_GROUP_NONE )
			end
		end
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
end
