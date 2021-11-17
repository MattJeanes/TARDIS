TARDIS:AddControl({
	id = "coordinates",
	ext_func=function(self,ply)
		TARDIS:PopToScreen("Destination", ply)
	end,
	serveronly = true,
	power_independent = false,
	screen_button = false, -- already added as a screen
	tip_text = "Coordinates",
})