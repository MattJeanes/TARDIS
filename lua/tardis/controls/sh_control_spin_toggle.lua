TARDIS:AddControl({
	id = "spin_toggle",
	ext_func=function(self,ply)
		self:ToggleSpin()
		if self:GetSpinDir() ~= 0 then
			TARDIS:Message(ply, "Spin direction set to " .. self:GetSpinDirText())
		end
		TARDIS:StatusMessage(ply, "Spin", (self:GetSpinDir() ~= 0))
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = false,
		mmenu = false,
	},
	tip_text = "Toggle spin",
})