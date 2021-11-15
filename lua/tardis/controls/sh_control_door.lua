TARDIS:AddControl({
	id = "door",
	ext_func=function(self,ply)
		local oldstate = self:GetData("doorstate")
		if self:ToggleDoor() then
			TARDIS:StatusMessage(ply, "Door", not oldstate, "opened", "closed")
		else
			TARDIS:ErrorMessage(ply, "Failed to ".. (oldstate and "close" or "open").." door")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 1},
		text = "Door",
		pressed_state_from_interior = false,
		pressed_state_data = "doorstate",
		order = 10,
	},
	tip_text = "Door Switch",
})