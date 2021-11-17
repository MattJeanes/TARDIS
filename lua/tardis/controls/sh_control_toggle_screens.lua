TARDIS:AddControl({
	id = "toggle_screens",
	int_func=function(self,ply)
		if self:ToggleScreens() then
			TARDIS:StatusMessage(ply, "Interior screens", self:GetData("screens_on"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle interior screens")
		end
	end,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		popup_only = true,
		toggle = true,
		frame_type = {2, 1},
		text = "Toggle Screen",
		pressed_state_from_interior = true,
		pressed_state_data = "screens_on",
		order = 1,
	},
	tip_text = "Toggle Screen",
})