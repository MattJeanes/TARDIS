-- Default Interior - Keyboard

local PART = {}
PART.ID = "default_keyboard"
PART.Name = "Default Keyboard"
PART.Control = "destination"
PART.Model = "models/drmatt/tardis/keyboard.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		TARDIS:Control("destination", ply)
	end
end

TARDIS:AddPart(PART)
