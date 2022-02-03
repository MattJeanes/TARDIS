-- Default Interior - Dematerialisation Circuit

local PART = {}
PART.ID = "default_dematcircuit"
PART.Name = "Default Dematerialisation Circuit"
PART.Text = "Dematerialisation Circuit"
PART.Model = "models/drmatt/tardis/smallbutton.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.Sound = "drmatt/tardis/seq_ok.wav"

TARDIS:AddPart(PART)
