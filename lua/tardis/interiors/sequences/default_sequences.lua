--Default Interior - Control Sequences (advanced mode)

local Seq = {
	ID = "default_sequences",

	["default_dematcircuit"] = {
		Controls = {
			"default_helmic",
			"default_physlock",
			"default_handbrake",
			"default_throttle"
		},
		OnFinish = function(self, ply, step, part)
			if IsValid(self) and IsValid(self) then
				self.exterior:Demat()
			end
		end,
		OnFail = function(self, ply, step, part)
			-- Fail stuff
		end,
		Condition = function(self)
			return self.exterior:GetData("vortex",false)==false and self.exterior:GetData("teleport",false)==false
		end
	}
}

TARDIS:AddControlSequence(Seq)