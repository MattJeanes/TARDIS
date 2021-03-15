-- Default Interior - Throttle

local PART = {}
PART.ID = "default_throttle"
PART.Name = "Default Throttle"
PART.Control = "throttle"
PART.Model = "models/drmatt/tardis/throttle.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_throttle.wav"

if SERVER then
	function PART:Use(ply)
		if self.exterior:GetData("teleport")==true or self.exterior:GetData("vortex")==true then
			self.exterior:Mat()
		end
		if self.interior:GetSequencesEnabled() then return end
		if self.exterior:GetData("teleport",false)==false or self.exterior:GetData("vortex",false)==false then
			self.exterior:Demat()
		end
	end
end

TARDIS:AddPart(PART)
