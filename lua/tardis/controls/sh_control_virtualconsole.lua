
TARDIS:AddControl({
	id = "virtualconsole",
	ext_func=function(self,ply)
		TARDIS:PopToScreen("Virtual Console", ply)
	end,
	serveronly = true,
	power_independent = true,
	screen_button = false, -- already added as a screen
	tip_text = "Virtual Console",
})