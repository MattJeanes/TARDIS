-- Default Interior - Anti-Gravs Pull Handle

local PART = {}
PART.ID = "default_float"
PART.Name = "Default Float"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/lever_on.wav"
PART.SoundOff = "drmatt/tardis/default/control_handbrake.wav"

TARDIS:AddPart(PART)