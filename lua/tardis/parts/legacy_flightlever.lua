--Legacy Interior - Flightmode Lever

local PART = {}
PART.ID = "legacy_flightlever"
PART.Name = "Legacy Flight Lever"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self.exterior:ToggleFlight()
        self:EmitSound("tardis/control_handbrake.wav")
    end
end

TARDIS:AddPart(PART)