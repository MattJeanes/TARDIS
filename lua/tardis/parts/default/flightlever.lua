-- Default Interior - Flightmode Lever

local PART = {}
PART.ID = "default_flightlever"
PART.Name = "Default Flight Lever"
PART.Control = "flight"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"

if SERVER then
	function PART:Use(ply)
		self.exterior:ToggleFlight()
	end
end

TARDIS:AddPart(PART)
