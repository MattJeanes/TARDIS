TARDIS:AddControl({
	id = "spin_switch",
	ext_func=function(self,ply)
		self:SwitchSpinDir()
		if self:GetSpinDir() ~= 0 then
			TARDIS:Message(ply, "Spin direction set to " .. self:GetSpinDirText())
		else
			TARDIS:Message(ply, "Spin is disabled, but spin direction set to " .. self:GetSpinDirText(true))
		end
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = false,
		mmenu = false,
	},
	tip_text = "Spin direction",
})