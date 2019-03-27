--Legacy Interior - HADS Switch

local PART = {}
PART.ID = "legacy_hads"
PART.Name = "Legacy HADS Switch"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self:EmitSound("tardis/control_handbrake.wav")
        self.exterior:ToggleHads()
    end
end
        

TARDIS:AddPart(PART)