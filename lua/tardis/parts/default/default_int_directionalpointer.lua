-- Default Interior - Directional Pointer

local PART = {}
PART.ID = "default_directionalpointer"
PART.Name = "Default Directional Pointer"
PART.Text = "Parts.DefaultDirectionalPointer.Text"
PART.Model = "models/drmatt/tardis/directionalpointer.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/controls/dir_pointer.wav"
PART.SoundOff = "p00gie/tardis/controls/dir_pointer_off.wav"

TARDIS:AddPart(PART)
