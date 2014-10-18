-- Adds matching interior door

local PART={}
PART.ID = "door"
PART.Name = "Door"
PART.Model = "models/drmatt/tardis/exterior/door.mdl"
PART.AutoSetup = true
PART.ClientThinkOverride = true

if SERVER then
	function PART:Initialize()		
		local int=self.interior		
		self:SetPos(int:LocalToWorld(Vector(-1.5,-309.5,82.7)))
		self:SetAngles(int:LocalToWorldAngles(Angle(0,-90,0)))
		self:SetParent(int)
	end
	
	function PART:Use()
		self.exterior:ToggleDoor()
	end
end
if CLIENT then
	function ENT:DoorOpen()
		local ext=self:GetNetEnt("exterior")
		return ext:DoorOpen()
	end
	
	function PART:Think()
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
			self:SetPoseParameter("switch", ext.DoorPos)
			self:InvalidateBoneCache()
		end
	end
end

ENT:AddPart(PART,e)