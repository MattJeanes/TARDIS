--Legacy Interior - Directional Pointer

local PART = {}
PART.ID = "legacy_directionalpointer"
PART.Name = "Legacy Directional Pointer"
PART.Model = "models/drmatt/tardis/directionalpointer.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)

    end
end
        

TARDIS:AddPart(PART)