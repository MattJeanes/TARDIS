-- Default Interior - Door frame

local PART = {}
PART.ID = "default_doorframe"
PART.Name = "Default Door Frame"
PART.Model = "models/drmatt/tardis/door.mdl"
PART.BypassIsomorphic = true
PART.AutoSetup = true
PART.Collision = false
PART.CollisionUse = false
PART.Animate = true

TARDIS:AddPart(PART)
