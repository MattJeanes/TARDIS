-- Default Interior - Cloaking Blacksticks

local PART = {}
PART.ID = "default_blacksticks"
PART.Name = "Default Cloaking Blacksticks"
PART.Model = "models/drmatt/tardis/blacksticks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/cloak_lever_on.wav"
PART.SoundOff = "p00gie/tardis/controls/cloak_lever_off.wav"

TARDIS:AddPart(PART)
