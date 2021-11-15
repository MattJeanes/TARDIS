TARDIS:AddControl({
	id = "music",
	ext_func=function(self,ply)
		TARDIS:PopToScreen("Music", ply)
	end,
	serveronly = true,
	screen_button = false, -- already added as a screen
	tip_text = "Music",
})