-- Default Interior - Typewriter

local PART = {}
PART.ID = "default_typewriter"
PART.Name = "Default Typewriter"
PART.Control = "coordinates"
PART.Model = "models/drmatt/tardis/typewriter.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		TARDIS:Control("coordinates", ply)
	end
end

TARDIS:AddPart(PART)
