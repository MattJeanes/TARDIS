--Legacy Interior - Repair Lever

local PART = {}
PART.ID = "legacy_repairlever"
PART.Name = "Legacy Repair Lever"
PART.Model = "models/drmatt/tardis/repairlever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self.exterior:StartAutorepair()
    end
end
        

TARDIS:AddPart(PART)