-- Lock

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

	function ENT:ActualSetLocked(locked,callback)
		self:SetData("locking",false,true)
		self:SetData("locked",locked,true)
		self:FlashLight(0.6)
		self:SendMessage("locksound")
		if callback then callback(true) end
	end

	function ENT:SetLocked(locked,callback)
		if locked then
			self:SetData("locking",true,true)
			self:CloseDoor(function(state)
				if state then
					if callback then callback(false) end
				else
					self:ActualSetLocked(true,callback)
				end
			end)
		else
			self:ActualSetLocked(false,callback)
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
			a:ChatPrint("This TARDIS is locked.")
			self:EmitSound("doors/door_lock_1.wav")
		end
	end)
else
	TARDIS:AddSetting({
		id="locksound-enabled",
		name="Lock Sound",
		desc="Whether a sound is made when toggling the lock or not",
		section="Misc",
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
