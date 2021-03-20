--Default Interior - Control Sequences (advanced mode)

local Seq = {
	ID = "default_sequences",

	["default_longflightdemat"] = {
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
			-- fail stuff
		end
	}
}

TARDIS:AddControlSequence(Seq)