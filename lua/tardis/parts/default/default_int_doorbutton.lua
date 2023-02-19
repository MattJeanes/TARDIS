-- Default Interior - Door button

local PART = {}
PART.ID = "default_doorbutton"
PART.Name = "Default Door Button"
PART.Model = "models/drmatt/tardis/longflighttoggle.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/controls/lever2.wav"

PART.PowerOffUse = false

TARDIS:AddPart(PART)
