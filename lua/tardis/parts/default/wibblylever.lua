-- Default Interior - Wibbly Lever

local PART = {}
PART.ID = "default_wibblylever"
PART.Name = "Default Wibbly lever"
PART.Model = "models/drmatt/tardis/wibblylever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		self.exterior:ToggleLocked()
	end
end

TARDIS:AddPart(PART)
