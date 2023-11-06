--Default Interior - Control Sequences (advanced mode)

local Seq = {
    ID = "legacy_sequences",

    ["legacy_dematcircuit"] = {
        Controls = {
            "legacy_helmic",
            "legacy_physlock",
            "legacy_handbrake",
            "legacy_throttle"
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
            return self:GetData("vortex",false)==false and self:GetData("teleport",false)==false
        end
    }
}

TARDIS:AddControlSequence(Seq)