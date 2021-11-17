TARDIS:AddControl({
	id = "hads",
	ext_func=function(self,ply)
		TARDIS:StatusMessage(ply, "Hostile Action Displacement System", self:ToggleHADS())
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "H.A.D.S.",
		pressed_state_from_interior = false,
		pressed_state_data = "hads",
		order = 14,
	},
	tip_text = "H.A.D.S.",
})