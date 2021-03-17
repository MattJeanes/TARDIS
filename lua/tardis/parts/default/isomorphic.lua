-- Default Interior - Isomorphic Security

local PART = {}
PART.ID = "default_isomorphic"
PART.Name = "Default Isomorphic Security"
PART.Control = "isomorphic"
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
    if self.interior:ToggleSecurity() then
        ply:ChatPrint("Isomorphic ".. (self.interior:GetSecurity() and "engaged" or "disengaged"))
    end
end
TARDIS:AddPart(PART)
