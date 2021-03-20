-- Default Interior - Gramophone

local PART = {}
PART.ID = "default_gramophone"
PART.Name = "Default Gramophone"
PART.Control = "music"
PART.Text = "Gramophone"
PART.Model = "models/drmatt/tardis/gramophone.mdl"
PART.AutoSetup = true
PART.Collision = true

if SERVER then
	function PART:Use(ply)
		TARDIS:Control("music", ply)
	end
end

TARDIS:AddPart(PART)
