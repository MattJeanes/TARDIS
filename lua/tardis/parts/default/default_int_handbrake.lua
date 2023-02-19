-- Default Interior - Handbrake

local PART = {}
PART.ID = "default_handbrake"
PART.Name = "Default Handbrake"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/handbrake_on.wav"
PART.SoundOff = "p00gie/tardis/controls/handbrake_off.wav"

TARDIS:AddPart(PART)
