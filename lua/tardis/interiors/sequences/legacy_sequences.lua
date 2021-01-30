--Legacy Interior - Control Sequences (advanced mode)

local Seq = {
	ID = "legacy_sequences",

	["legacy_longflightdemat"] = {
		Controls = {
			"legacy_helmic",
			"legacy_physbrake",
			"legacy_handbrake",
			"legacy_throttle"
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