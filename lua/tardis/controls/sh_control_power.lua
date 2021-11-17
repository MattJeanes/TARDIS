TARDIS:AddControl({
	id = "power",
	ext_func=function(self,ply)
		if self:TogglePower() then
			TARDIS:StatusMessage(ply, "Power", self:GetData("power-state"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle power")
		end
	end,
	serveronly=true,
	power_independent = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Power",
		pressed_state_from_interior = false,
		pressed_state_data = "power-state",
		order = 2,
	},
	tip_text = "Power Switch",
})