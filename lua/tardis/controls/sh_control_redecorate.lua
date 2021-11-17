TARDIS:AddControl({
	id = "redecorate",
	ext_func=function(self,ply)
		local on = self:GetData("redecorate", false)
		on = self:SetData("redecorate", not on, true)

		local chosen_int = TARDIS:GetSetting("redecorate-interior","default",self:GetCreator())

		if on and (chosen_int == self.metadata.ID) then
			TARDIS:ErrorMessage(ply, "New interior has not been selected")
		elseif on and not self:GetData("repair-primed") then
			TARDIS:Message(ply, "Hint: enable self-repair to start redecoration")
			-- We print this first for it to be lower in the list
		end
		TARDIS:StatusMessage(ply, "Redecoration", on)
	end,
	serveronly=true,
	power_independent = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 1},
		text = "Redecoration",
		pressed_state_from_interior = false,
		pressed_state_data = "redecorate",
		order = 4,
	},
	tip_text = "Redecoration",
})