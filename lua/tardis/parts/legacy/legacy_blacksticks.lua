-- Legacy Interior - Cloaking Blacksticks

local PART = {}
PART.ID = "legacy_blacksticks"
PART.Name = "Legacy Cloaking Blacksticks"
PART.Model = "models/drmatt/tardis/blacksticks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)

    end
end
        

TARDIS:AddPart(PART)
