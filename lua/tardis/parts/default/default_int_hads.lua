-- Default Interior - HADS Switch

local PART = {}
PART.ID = "default_hads"
PART.Name = "Default HADS Switch"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "drmatt/tardis/default/control_handbrake.wav"

TARDIS:AddPart(PART)
