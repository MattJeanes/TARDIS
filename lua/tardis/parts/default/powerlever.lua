-- Default Interior - Power Lever

local PART = {}
PART.ID = "default_powerlever"
PART.Name = "Default Power Lever"
PART.Control = "power"
PART.Model = "models/drmatt/tardis/flightlever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		self.interior:TogglePower()
	end
end

TARDIS:AddPart(PART)
