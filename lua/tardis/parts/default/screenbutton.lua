-- Default Interior - Long Flight Demat Switch

local PART = {}
PART.ID = "default_screenbutton"
PART.Name = "Default Screen Button"
PART.Model = "models/drmatt/tardis/smallbutton.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		self.interior:ToggleScreens()
	end
end

TARDIS:AddPart(PART)
