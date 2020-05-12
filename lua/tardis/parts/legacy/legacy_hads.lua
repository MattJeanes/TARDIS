-- Legacy Interior - HADS Switch

local PART = {}
PART.ID = "legacy_hads"
PART.Name = "Legacy HADS Switch"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"

if SERVER then
    function PART:Use(ply)
        self.exterior:ToggleHads()
    end
end

TARDIS:AddPart(PART)
