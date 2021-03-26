-- Lock

TARDIS:AddControl({
	id = "doorlock",
	ext_func=function(self,ply)
		self:ToggleLocked(function(result)
			if result then
				TARDIS:StatusMessage(ply, "Door", self:GetData("locked"), "locked", "unlocked")
			else
				TARDIS:ErrorMessage(ply, "Failed to toggle door lock")
			end
		end)
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {1, 2},
		text = "Door Lock",
		pressed_state_from_interior = false,
		pressed_state_data = "locked",
		order = 6,
	},
	tip_text = "Door Lock",
})

function ENT:Locked()
	return self:GetData("locked",false)
end

function ENT:Locking()
	return self:GetData("locking",false)
end

if SERVER then
	function ENT:ToggleLocked(callback)
		self:SetLocked(not self:Locked(),callback)
	end

	function ENT:ActualSetLocked(locked,callback,silent)
		self:SetData("locking",false,true)
		self:SetData("locked",locked,true)
		self:FlashLight(0.6)
		if not silent then self:SendMessage("locksound") end
		if callback then callback(true) end
	end

	function ENT:SetLocked(locked,callback, silent)
		if not self:CallHook("CanLock") then return end
		if locked then
			self:SetData("locking",true,true)
			self:CloseDoor(function(state)
				if state then
					if callback then callback(false) end
				else
					self:ActualSetLocked(true,callback,silent)
				end
			end)
		else
			self:ActualSetLocked(false,callback,silent)
		end
	end
	
	ENT:AddHook("CanPlayerEnter","lock",function(self,ply)
		if self:Locked() then
			return false
		end
	end)

	ENT:AddHook("CanToggleDoor","lock",function(self,state)
		if (not state) and self:Locked() then
			return false
		end
	end)
	
	ENT:AddHook("Use", "lock", function(self,a,c)
		if self:GetData("locked") and IsValid(a) and a:IsPlayer() then
			if self:CallHook("LockedUse",a,c)==nil then
                TARDIS:Message(a, "This TARDIS is locked.")
			end
			self:EmitSound(self.metadata.Exterior.Sounds.Door.locked)
		end
	end)

	ENT:AddHook("HandleE2", "lock", function(self,name,e2)
		if name == "GetLocked" then
			if self:Locked() or self:Locking() then
				return 1
			else
				return 0
			end
		elseif name == "Lock" and TARDIS:CheckPP(e2.player, self) then
			self:ToggleLocked()
			return self:CallHook("CanLock") == true and 1 or 0
		end
	end)
else
	TARDIS:AddSetting({
		id="locksound-enabled",
		name="Lock Sound",
		desc="Whether a sound is made when toggling the lock or not",
		section="Sound",
		value=true,
		type="bool",
		option=true
	})

	ENT:OnMessage("locksound",function(self)
		local snd = self.metadata.Exterior.Sounds.Lock
		if TARDIS:GetSetting("locksound-enabled") and TARDIS:GetSetting("sound") then
			self:EmitSound(snd)
			if IsValid(self.interior) then
				self.interior:EmitSound(snd)
			end
		end
	end)
end
