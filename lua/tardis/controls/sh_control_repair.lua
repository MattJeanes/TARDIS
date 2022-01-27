TARDIS:AddControl({
	id = "repair",
	ext_func=function(self,ply)
		if not self:ToggleRepair() then
			TARDIS:ErrorMessage(ply, "Failed to toggle self-repair")
		end
	end,
	serveronly=true,
	power_independent = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 1},
		text = "Self-Repair",
		pressed_state_from_interior = false,
		pressed_state_data = "repair-primed",
		order = 3,
	},
	tip_text = "Self-Repair",
})