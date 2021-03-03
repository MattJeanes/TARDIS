-- Legacy Interior - Physics Lock

local PART = {}
PART.ID = "legacy_physbrake"
PART.Name = "Legacy Physics Lock"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"
PART.BypassIsomorphic = false

if SERVER then
	function PART:Use(ply)
		local result = self.exterior:TogglePhyslock() or false
		ply:ChatPrint("Physics Lock ".. (result and "engaged" or "disengaged"))
	end
end

TARDIS:AddPart(PART)
