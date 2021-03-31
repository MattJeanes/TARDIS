TARDIS:AddControl({
	id = "handbrake",
	ext_func=function(self, ply)
		if self:ToggleHandbrake() then
			TARDIS:StatusMessage(ply, "Time Rotor Handbrake", self:GetData("handbrake"), "engaged", "disengaged")
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle the Time Rotor Handbrake")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 2},
		text = "Time Rotor Handbrake",
		pressed_state_from_interior = false,
		pressed_state_data = "handbrake", -- can be changed
		order = 12,
	},
	tip_text = "Time Rotor Handbrake",
})

ENT:AddHook("Initialize","handbrake-init", function(self)
	self:SetData("handbrake", false, true)
end)

if SERVER then
	function ENT:ToggleHandbrake()
		return self:SetHandbrake(not self:GetData("handbrake"))
	end
	function ENT:SetHandbrake(on)
		if (self:CallHook("CanToggleHandbrake") == false
			or self.interior:CallHook("CanToggleHandbrake")) == false
		then
			return false
		end
		self:SetData("handbrake", on, true)
		self:CallHook("HandbrakeToggled", on)
		if self.interior then
			self.interior:CallHook("HandbrakeToggled", on)
		end
		return true
	end

	ENT:AddHook("FailDemat", "handbrake", function(self, force)
		if self:GetData("handbrake") and force ~= true then
			return true
		end
	end)

	ENT:AddHook("HandbrakeToggled", "vortex", function(self, force)
		if self:GetData("handbrake") then
			if self:GetData("teleport") or self:GetData("vortex") then
				self:InterruptTeleport()
			end
		end
	end)
end