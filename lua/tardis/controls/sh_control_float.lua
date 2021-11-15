TARDIS:AddControl({
	id = "float",
	ext_func=function(self,ply)
		if self:ToggleFloat() then
			TARDIS:StatusMessage(ply, "Anti-gravs", self:GetData("float"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle anti-gravs")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Anti-Gravs",
		pressed_state_from_interior = false,
		pressed_state_data = "float",
		order = 11,
	},
	tip_text = "Anti-Gravs",
})