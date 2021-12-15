TARDIS:AddControl({
	id = "door",
	ext_func=function(self,ply)
		local oldstate = self:GetData("doorstate")

		if self:GetData("locked", false) then
			TARDIS:ErrorMessage(ply, "The doors are locked.")
			return
		end

		if not self:GetPower() then
			if not self.metadata.EnableClassicDoors or oldstate then
				TARDIS:ErrorMessage(ply, "The door switch doesn't work.")
				TARDIS:ErrorMessage(ply, "Power is disabled.")
				return
			end
			TARDIS:Message(ply, "Using emergency power to open the door...")
			TARDIS:ErrorMessage(ply, "Power is disabled.")
		end

		if self:ToggleDoor() then
			TARDIS:StatusMessage(ply, "Door", not oldstate, "opened", "closed")
		else
			TARDIS:ErrorMessage(ply, "Failed to ".. (oldstate and "close" or "open").." door")
		end
	end,
	serveronly=true,
	power_independent = true,
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