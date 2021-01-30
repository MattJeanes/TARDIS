-- Legacy Interior - Flightmode Lever

local PART = {}
PART.ID = "legacy_flightlever"
PART.Name = "Legacy Flight Lever"
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
