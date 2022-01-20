TARDIS:AddControl({
	id = "thirdperson_careful",
	ext_func=function(self,ply)
		if ply:KeyDown(IN_WALK) then
			self:PlayerThirdPerson(ply, not ply:GetTardisData("thirdperson"))
		else
			TARDIS:Message(ply, "HINT: Use USE + WALK keys to open third person control (default: ALT + E)")
		end
	end,
	serveronly=true,
	power_independent = true,
	screen_button = false,
	tip_text = "Manual Flight Control",
})