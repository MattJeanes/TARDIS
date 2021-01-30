-- Legacy Interior - Fast Return Lever

local PART = {}
PART.ID = "legacy_biglever"
PART.Name = "Legacy Fast Return Lever"
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
