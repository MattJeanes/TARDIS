TARDIS:AddControl({
	id = "destination",
	ext_func=function(self,ply)
		self:SelectDestination(ply, true)
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = false,
		mmenu = true,
		toggle = false,
		frame_type = {0, 1},
		text = "Destination",
		order = 4,
	},
	tip_text = "Destination Select",
})
