TARDIS:AddControl({ id = "teleport",
	ext_func=function(self,ply)
		if (self:GetData("teleport") or self:GetData("vortex")) then
			self:Mat(function(result)
				if result then
					TARDIS:Message(ply, "Materialising")
				else
					TARDIS:ErrorMessage(ply, "Failed to materialise")
				end
			end)
		else
			local pos = pos or self:GetData("demat-pos") or self:GetPos()
			local ang = ang or self:GetData("demat-ang") or self:GetAngles()
			self:Demat(pos, ang, function(result)
				if result then
					TARDIS:Message(ply, "Dematerialising")
				else
					if self:GetData("doorstatereal", false) then
						TARDIS:ErrorMessage(ply, "Can't dematerialise while doors are open")
					elseif self:GetData("handbrake", false) then
						TARDIS:ErrorMessage(ply, "Time Rotor Handbrake is engaged! Cannot dematerialise")
					else
						TARDIS:ErrorMessage(ply, "Failed to dematerialise")
					end
				end
			end)
		end
	end,
	serveronly=true,
	power_independent = false,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 1},
		text = "Teleport",
		pressed_state_from_interior = false,
		pressed_state_data = {"teleport", "vortex"},
		order = 6,
	},
	tip_text = "Space-Time Throttle",
})