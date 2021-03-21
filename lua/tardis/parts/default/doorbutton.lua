-- Default Interior - Door button

local PART = {}
PART.ID = "default_doorbutton"
PART.Name = "Default Door Button"
PART.Control = "door"
PART.Model = "models/drmatt/tardis/smallbutton.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

TARDIS:AddPart(PART)
