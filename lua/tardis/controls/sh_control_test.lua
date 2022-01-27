TARDIS:AddControl({
	id = "test",
	ext_func = function(self,ply)
		if CLIENT then
			TARDIS:Message(LocalPlayer(), "CLIENT: "..tostring(self))
		else
			TARDIS:Message(ply, "SERVER: "..tostring(self))
		end
	end,
	int_func = function(self,ply)
		if CLIENT then
			TARDIS:Message(LocalPlayer(), "CLIENT: "..tostring(self))
		else
			TARDIS:Message(ply, "SERVER: "..tostring(self))
		end
	end,
	screen_button = false,
	power_independent = false,
	tip_text = "Test",
})