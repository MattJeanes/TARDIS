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
	power_independent = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 2},
		text = "Time Rotor Handbrake",
		pressed_state_from_interior = false,
		pressed_state_data = "handbrake", -- can be changed
		order = 7,
	},
	tip_text = "Time Rotor Handbrake",
})