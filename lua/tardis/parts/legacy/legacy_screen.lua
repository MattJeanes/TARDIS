--Legacy Interior - Screen

local PART = {}
PART.ID = "legacy_screen"
PART.Name = "Legacy Screen"
PART.Model = "models/drmatt/tardis/screen.mdl"
PART.AutoSetup = true
PART.Collision = true

if SERVER then
    function PART:Use(ply)
        
    end
end
        

TARDIS:AddPart(PART)