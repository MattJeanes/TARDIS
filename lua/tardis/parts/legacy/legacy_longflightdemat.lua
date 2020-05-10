-- Legacy Interior - Long Flight Demat Switch

local PART = {}
PART.ID = "legacy_longflightdemat"
PART.Name = "Legacy Long Flight Demat Switch"
PART.Model = "models/drmatt/tardis/smallbutton.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)

    end
end
        

TARDIS:AddPart(PART)
