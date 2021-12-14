TARDIS:AddControl({
	id = "interior_lights",
	ext_func=function(self,ply)
		TARDIS:Message(ply, "This hasn't been implemented yet.")
	end,
	clientonly=true,
	power_independent = false,
	screen_button = {
		virt_console = false,
		mmenu = false,
	},
	tip_text = "Lights",
})