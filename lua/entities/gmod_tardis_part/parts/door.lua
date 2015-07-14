-- Adds matching interior door

local PART={}
PART.ID = "door"
PART.Name = "Door"
PART.Model = "models/drmatt/tardis/exterior/door.mdl"
PART.AutoSetup = true
PART.ClientThinkOverride = true
PART.ClientDrawOverride = true
PART.Collision = true
PART.NoStrictUse = true

if SERVER then
	function PART:Initialize()	
		self:SetBodygroup(1,1) -- Sticker
		self:SetBodygroup(2,1) -- Lit sign
		self:SetBodygroup(3,1) -- 3D sign
	end
	
	function PART:Use(a)
		if a:KeyDown(IN_WALK) then
			self.exterior:PlayerExit(a)
		else
			self.exterior:ToggleDoor()
		end
	end
else
	function ENT:DoorOpen()
		return self.exterior:DoorOpen()
	end
	
	function PART:Think()
		if IsValid(self.exterior) then
			self:SetPoseParameter("switch", self.exterior.DoorPos)
			self:InvalidateBoneCache()
		end
	end
end

ENT:AddPart(PART,e)