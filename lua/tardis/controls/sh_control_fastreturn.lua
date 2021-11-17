TARDIS:AddControl({ id = "fastreturn",
	ext_func=function(self,ply)
		self:FastReturn(function(result)
			if result then
				TARDIS:Message(ply, "Fast-return protocol initiated")
			else
				TARDIS:ErrorMessage(ply, "Failed to initiate fast-return protocol")
			end
		end)
	end,
	serveronly = true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = false,
		frame_type = {0, 1},
		text = "Fast Return",
		order = 9,
	},
	tip_text = "Fast Return Protocol",
})