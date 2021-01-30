-- Legacy Interior - Long Flight Toggle

local PART = {}
PART.ID = "legacy_longflighttoggle"
PART.Name = "Legacy Long Flight Toggle"
PART.Model = "models/drmatt/tardis/longflighttoggle.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		self.exterior:ToggleFastRemat()
		ply:ChatPrint("Vortex flightmode is now ".. (self.exterior:GetData("demat-fast",false) and "off" or "on"))
	end
end

TARDIS:AddPart(PART)
