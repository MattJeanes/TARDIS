TARDIS:AddControl({
	id = "doorlock",
	ext_func=function(self,ply)
		if not self:GetPower() and not self:GetData("locked", false) then
			TARDIS:ErrorMessage(ply, "The door lock doesn't work.")
			TARDIS:ErrorMessage(ply, "Power is disabled.")
			return
		elseif not self:GetPower() then
			TARDIS:Message(ply, "Using emergency power to disengage the lock...")
			TARDIS:ErrorMessage(ply, "Power is disabled.")
		end

		self:ToggleLocked(function(result)
			if result then
				TARDIS:StatusMessage(ply, "Door", self:GetData("locked"), "locked", "unlocked")
			else
				TARDIS:ErrorMessage(ply, "Failed to toggle door lock")
			end
		end)
	end,
	serveronly=true,
	power_independent = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {1, 2},
		text = "Door Lock",
		pressed_state_from_interior = false,
		pressed_state_data = "locked",
		order = 10,
	},
	tip_text = "Door Lock",
})