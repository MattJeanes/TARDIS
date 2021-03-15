-- Default Interior - Typewriter

local PART = {}
PART.ID = "default_typewriter"
PART.Name = "Default Typewriter"
PART.Control = "coords"
PART.Model = "models/drmatt/tardis/typewriter.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		if not ply:IsPlayer() then return end
		TARDIS:PopToScreen("Destination",ply)
	end
end

TARDIS:AddPart(PART)
