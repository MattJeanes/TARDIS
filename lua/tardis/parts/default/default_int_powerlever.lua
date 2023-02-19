-- Default Interior - Power Lever

local PART = {}
PART.ID = "default_powerlever"
PART.Name = "Default Power Lever"
PART.Model = "models/drmatt/tardis/flightlever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/lever1.wav"
PART.SoundOff = "p00gie/tardis/controls/lever1_off.wav"

TARDIS:AddPart(PART)
