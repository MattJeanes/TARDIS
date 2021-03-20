-- Default Interior - Fast Return Lever

local PART = {}
PART.ID = "default_biglever"
PART.Name = "Default Fast Return Lever"
PART.Control = "fastreturn"
PART.Model = "models/drmatt/tardis/biglever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
	function PART:Use(ply)
		self.exterior:FastReturn()
	end
end

TARDIS:AddPart(PART)
