TARDIS:AddControl({
	id = "engine_release",
	ext_func=function(self, ply)
		local pos = pos or self:GetData("demat-pos") or self:GetPos()
		local ang = ang or self:GetData("demat-ang") or self:GetAngles()
		self:EngineReleaseDemat(pos, ang, function(result)
			if result then
				TARDIS:Message(ply, "Force dematerialisation triggered")
			elseif result == false then
				TARDIS:ErrorMessage(ply, "Failed to dematerialise")
			end
		end)
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = false,
		frame_type = {0, 1},
		text = "Engine Release",
		order = 8,
	},
	tip_text = "Engine Release",
})