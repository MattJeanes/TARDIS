--Legacy Interior - Handbrake

local PART = {}
PART.ID = "legacy_handbrake"
PART.Name = "Legacy Handbrake"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self:EmitSound("tardis/control_handbrake.wav")
    end
end
        

TARDIS:AddPart(PART)