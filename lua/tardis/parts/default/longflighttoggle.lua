-- Default Interior - Long Flight Toggle

local PART = {}
PART.ID = "default_longflighttoggle"
PART.Name = "Default Long Flight Toggle"
PART.Control = "long_flight"
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
