-- Default Interior - Isomorphic Security

local PART = {}
PART.ID = "default_isomorphic"
PART.Name = "Default Isomorphic Security"
PART.Control = "isomorphic"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "drmatt/tardis/default/control_handbrake.wav"

function PART:Use(ply)
	TARDIS:Control("isomorphic", ply)
end
TARDIS:AddPart(PART)
