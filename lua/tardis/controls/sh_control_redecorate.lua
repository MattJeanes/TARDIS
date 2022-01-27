TARDIS:AddControl({
	id = "redecorate",
	ext_func=function(self,ply)
		if ply ~= self:GetCreator() then
			TARDIS:ErrorMessage(ply, "You cannot redecorate someone else's TARDIS")
			return
		end

		local on = not self:GetData("redecorate", false)
		self:SetData("redecorate", on, true)
		TARDIS:StatusMessage(ply, "Redecoration", on)

		if not self:GetData("redecorate", false) then
			return
		end

		local chosen_int = TARDIS:GetSetting("redecorate-interior", "default", ply)
		if chosen_int == self.metadata.ID then
			TARDIS:Message(ply, "WARNING: New interior has been selected randomly. Right click in spawnmenu to choose")
			while chosen_int == self.metadata.ID or TARDIS.Metadata[chosen_int].Base == true do
				chosen_int = table.Random(TARDIS.Metadata).ID
			end
		end
		self:SetData("redecorate-interior", chosen_int)

		if not self:GetData("repair-primed") and not self:SetRepair(true) then
			TARDIS:ErrorMessage(ply, "Failed to toggle redecoration")
		end
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