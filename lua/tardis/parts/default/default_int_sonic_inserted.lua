-- Default Interior - Sonic charger

local PART = {}
PART.ID = "default_sonic_inserted"
PART.Name = "Default Sonic Screwdriver in the charger"
PART.Control = "sonic_dispenser"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Model = "models/weapons/c_sonicsd.mdl"

TARDIS:AddPart(PART)