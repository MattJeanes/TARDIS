TARDIS:AddControl({
	id = "cloak",
	ext_func=function(self,ply)
		self:ToggleCloak()
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 1},
		text = "Cloaking",
		pressed_state_from_interior = false,
		pressed_state_data = "cloak",
		order = 12,
	},
	tip_text = "Cloaking Device",
})