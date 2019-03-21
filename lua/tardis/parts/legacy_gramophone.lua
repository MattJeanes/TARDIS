--Legacy Interior - Gramophone

local PART = {}
PART.ID = "legacy_gramophone"
PART.Name = "Legacy Gramophone"
PART.Model = "models/drmatt/tardis/gramophone.mdl"
PART.AutoSetup = true
PART.Collision = true

if SERVER then
    function PART:Use(ply)
        
    end
end
        

TARDIS:AddPart(PART)