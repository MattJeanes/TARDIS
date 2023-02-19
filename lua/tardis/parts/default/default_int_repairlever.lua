-- Default Interior - Repair Lever

local PART = {}
PART.ID = "default_repairlever"
PART.Name = "Default Repair Lever"
PART.Model = "models/drmatt/tardis/repairlever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/lever1.wav"
PART.SoundOff = "p00gie/tardis/controls/lever1_off.wav"


TARDIS:AddPart(PART)
