TARDIS:AddControl({
	id = "physlock",
	ext_func=function(self,ply)
		if self:TogglePhyslock() then
			TARDIS:StatusMessage(ply, "Locking-down mechanism", self:GetData("physlock"), "engaged", "disengaged")
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle locking-down mechanism")
		end
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 2},
		text = "Physlock",
		pressed_state_from_interior = false,
		pressed_state_data = "physlock",
		order = 12,
	},
	tip_text = "Locking-Down Mechanism",
})