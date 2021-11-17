TARDIS:AddControl({
	id = "thirdperson",
	ext_func=function(self,ply)
		self:PlayerThirdPerson(ply, not ply:GetTardisData("thirdperson"))
	end,
	serveronly=true,
	power_independent = true,
	screen_button = {
		virt_console = false,
		mmenu = true,
		toggle = false,
		frame_type = {0, 1},
		text = "Flight Control",
		order = 5,
	},
	tip_text = "Manual Flight Control",
})