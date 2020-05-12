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
        OnFinish = function(self)
            if IsValid(self) and IsValid(self) then
                self.exterior:Demat()
            end
        end
    }
}

TARDIS:AddControlSequence(Seq)