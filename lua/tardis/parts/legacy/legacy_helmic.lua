--Legacy Interior - Helmic Regulator

local PART = {}
PART.ID = "legacy_helmic"
PART.Name = "Legacy Helmic Regulator"
PART.Model = "models/drmatt/tardis/helmicregulator.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AutomaticFrameAdvance = true

if SERVER then
    function PART:Use(ply)

    end
end
        

TARDIS:AddPart(PART)