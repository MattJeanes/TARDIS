-- Legacy Interior - Handbrake

local PART = {}
PART.ID = "legacy_handbrake"
PART.Name = "Legacy Handbrake"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"
PART.BypassIsomorphic = false

TARDIS:AddPart(PART)
