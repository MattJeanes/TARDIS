-- Default Interior - Flightmode Lever

local PART = {}
PART.ID = "default_flightlever"
PART.Name = "Default Flight Lever"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "drmatt/tardis/default/control_handbrake.wav"

TARDIS:AddPart(PART)
