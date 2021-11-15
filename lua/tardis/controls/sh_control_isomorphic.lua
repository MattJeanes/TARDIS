TARDIS:AddControl({
	id = "isomorphic",
	int_func=function(self,ply)
		if ply ~= self:GetCreator() then
			TARDIS:ErrorMessage(ply, "This is not your TARDIS")
			return
		end
		if self:ToggleSecurity() then
			TARDIS:StatusMessage(ply, "Isomorphic security", self:GetData("security"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle isomorphic security")
		end
	end,
	serveronly = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Isomorphic Security",
		pressed_state_from_interior = true,
		pressed_state_data = "security",
		order = 15,
	},
	tip_text = "Isomorphic Security System",
})