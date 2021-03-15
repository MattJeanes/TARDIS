-- Legacy Interior - Isomorphic Security

local PART = {}
PART.ID = "legacy_isomorphic"
PART.Name = "Legacy Isomorphic Security"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"

function PART:Use(ply)
    if ply~=self.interior:GetCreator() then
        ply:ChatPrint("This is not your TARDIS")
        return
    end
    local result = self.interior:ToggleSecurity() or false
    ply:ChatPrint("Isomorphic ".. (result and "engaged" or "disengaged"))
end
TARDIS:AddPart(PART)
