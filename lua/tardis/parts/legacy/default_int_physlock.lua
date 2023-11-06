-- Default Interior - Physics Lock

local PART = {}
PART.ID = "default_physlock"
PART.Name = "Default Physics Lock"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "drmatt/tardis/default/control_handbrake.wav"

TARDIS:AddPart(PART)
