-- Placeholder handbrake module (currently only for control presets, feel free to delete later)

-- We add this earlier so that extension creators could add them
TARDIS:AddControl({
	id = "handbrake",
	ext_func=function(self, ply)
		-- Code will be added here

		TARDIS:ErrorMessage(ply, "Handbrake is not yet implemented")
	end,
	serveronly=true,
	screen_button = {
		virt_console = false, -- change to true to add
		mmenu = false,
		toggle = true,
		frame_type = {0, 2},
		text = "Time-Rotor Handbrake",
		pressed_state_from_interior = false,
		pressed_state_data = "handbrake", -- can be changed
		order = 12,
	},
	tip_text = "Time-Rotor Handbrake",
})