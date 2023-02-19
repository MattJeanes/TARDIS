-- Default Interior - Physics Lock

local PART = {}
PART.ID = "default_physlock"
PART.Name = "Default Physics Lock"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/handbrake_on.wav"
PART.SoundOff = "p00gie/tardis/controls/lever_on.wav"

TARDIS:AddPart(PART)
