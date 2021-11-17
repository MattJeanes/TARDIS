TARDIS:AddControl({
	id = "settings",
	ext_func=function(self,ply)
		TARDIS:PopToScreen("Settings", ply)
	end,
	power_independent = true,
	serveronly = true,
	screen_button = false, -- already added as a screen
	tip_text = "Settings",
})