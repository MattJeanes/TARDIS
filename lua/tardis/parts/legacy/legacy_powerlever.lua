-- Legacy Interior - Power Lever

local PART = {}
PART.ID = "legacy_powerlever"
PART.Name = "Legacy Power Lever"
PART.Model = "models/drmatt/tardis/flightlever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.BypassIsomorphic = false

if SERVER then
	function PART:Use(ply)
		self.interior:TogglePower()
	end
end

TARDIS:AddPart(PART)
