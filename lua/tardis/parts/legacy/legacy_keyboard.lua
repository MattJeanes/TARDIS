-- Legacy Interior - Keyboard

local PART = {}
PART.ID = "legacy_keyboard"
PART.Name = "Legacy Keyboard"
PART.Model = "models/drmatt/tardis/keyboard.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)

    end
end
        

TARDIS:AddPart(PART)
