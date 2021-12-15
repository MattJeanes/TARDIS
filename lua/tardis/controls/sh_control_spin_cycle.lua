TARDIS:AddControl({
	id = "spin_cycle",
	ext_func=function(self,ply)
		self:CycleSpinDir()
		TARDIS:Message(ply, "Spin direction set to " .. self:GetSpinDirText())
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = false,
		frame_type = {0, 1},
		text = "Spin direction",
		pressed_state_from_interior = false,
		pressed_state_data = nil,
		order = 16,
	},
	tip_text = "Spin",
})