TARDIS:AddControl({
	id = "flight",
	ext_func=function(self,ply)
		if self:ToggleFlight() then
			TARDIS:StatusMessage(ply, "Flight mode", self:GetData("flight"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle flight mode")
		end
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Flight Mode",
		pressed_state_from_interior = false,
		pressed_state_data = "flight",
		order = 10,
	},
	tip_text = "Flight Mode"
})