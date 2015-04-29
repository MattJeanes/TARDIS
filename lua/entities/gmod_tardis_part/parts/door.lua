-- Adds matching interior door

local PART={}
PART.ID = "door"
PART.Name = "Door"
PART.Model = "models/drmatt/tardis/exterior/door.mdl"
PART.AutoSetup = true
PART.ClientThinkOverride = true
PART.ClientDrawOverride = true
PART.Collision = true

if SERVER then
	function PART:Initialize()	
		self:SetBodygroup(1,1) -- Sticker
		self:SetBodygroup(2,1) -- Lit sign
		self:SetBodygroup(3,1) -- 3D sign
		
		local int=self.interior
		self:SetPos(int:LocalToWorld(Vector(-1,-327.5,84.35)))
		self:SetAngles(int:LocalToWorldAngles(Angle(0,-90,0)))
		self:SetParent(int)
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
		local ext=self:GetNetEnt("exterior")
		return ext:DoorOpen()
	end
	
	function PART:DoThink()
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
			self:SetPoseParameter("switch", ext.DoorPos)
			self:InvalidateBoneCache()
		end
	end
end

ENT:AddPart(PART,e)