-- Legacy Interior - Unused Pull Handle

local PART = {}
PART.ID = "legacy_float"
PART.Name = "Legacy Float"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"

if SERVER then
	function PART:Use(ply)
		if self.exterior:ToggleFloat() then
			ply:ChatPrint("Anti-gravs ".. (self.exterior:GetData("float") and "enabled" or "disabled"))
		else
			ply:ChatPrint("Failed to toggle anti-gravs")
		end
	end
end

TARDIS:AddPart(PART)