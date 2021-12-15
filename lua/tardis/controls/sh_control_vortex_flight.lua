TARDIS:AddControl({ id = "vortex_flight",
	ext_func=function(self,ply)
		if self:ToggleFastRemat() then
			TARDIS:StatusMessage(ply, "Vortex flight", self:GetData("demat-fast"), "disabled", "enabled")
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle vortex flight")
		end
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {1, 2},
		text = "Vortex Flight",
		pressed_state_from_interior = false,
		pressed_state_data = "demat-fast",
		order = 8,
	},
	tip_text = "Vortex Flight",
})