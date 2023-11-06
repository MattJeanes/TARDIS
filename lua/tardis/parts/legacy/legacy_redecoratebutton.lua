-- Default Interior - Redecorate button

local PART = {}
PART.ID = "default_redecoratebutton"
PART.Name = "Default Redecotate Button"
PART.Model = "models/drmatt/tardis/smallbutton.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.SoundOn = "drmatt/tardis/seq_ok.wav"
PART.SoundOff = "drmatt/tardis/seq_bad.wav"

TARDIS:AddPart(PART)
