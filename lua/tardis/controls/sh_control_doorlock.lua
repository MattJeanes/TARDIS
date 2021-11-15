TARDIS:AddControl({
	id = "doorlock",
	ext_func=function(self,ply)
		self:ToggleLocked(function(result)
			if result then
				TARDIS:StatusMessage(ply, "Door", self:GetData("locked"), "locked", "unlocked")
			else
				TARDIS:ErrorMessage(ply, "Failed to toggle door lock")
			end
		end)
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {1, 2},
		text = "Door Lock",
		pressed_state_from_interior = false,
		pressed_state_data = "locked",
		order = 10,
	},
	tip_text = "Door Lock",
})