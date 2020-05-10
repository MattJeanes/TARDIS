-- Legacy Interior - Isomorphic Security

local PART = {}
PART.ID = "legacy_isomorphic"
PART.Name = "Legacy Isomorphic Security"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self:EmitSound("tardis/control_handbrake.wav")
        self.interior:TogglePartsPerms()
    end
end
        

TARDIS:AddPart(PART)
