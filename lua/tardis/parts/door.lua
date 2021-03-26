-- Adds matching interior door

local PART={}
PART.ID = "door"
PART.Name = "Door"
PART.Model = "models/drmatt/tardis/exterior/door.mdl"
PART.AutoSetup = true
PART.AutoPosition = false
PART.ClientThinkOverride = true
PART.Collision = true
PART.NoStrictUse = true
PART.ShouldTakeDamage = true
PART.BypassIsomorphic = true

if SERVER then
	function PART:Initialize()	
		self:SetBodygroup(1,1) -- Sticker
		self:SetBodygroup(2,1) -- Lit sign
		
		if self.ExteriorPart then
			self.ClientDrawOverride = true
			self:SetSolid(SOLID_VPHYSICS)
			--self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		elseif self.InteriorPart then
			self.DrawThroughPortal = true
			self:SetBodygroup(3,1) -- 3D sign
			table.insert(self.interior.stuckfilter, self)
		end
		
		local metadata=self.exterior.metadata
		local portal=self.ExteriorPart and metadata.Exterior.Portal or metadata.Interior.Portal
		if portal then
			local pos=(self.posoffset or Vector(26*(self.InteriorPart and 1 or -1),0,-51.65))
			local ang=(self.angoffset or Angle(0,self.InteriorPart and 180 or 0,0))
			pos,ang=LocalToWorld(pos,ang,portal.pos,portal.ang)
			self:SetPos(self.parent:LocalToWorld(pos))
			self:SetAngles(self.parent:LocalToWorldAngles(ang))
			self:SetParent(self.parent)
		end
	end
	
	function PART:Use(a)
		if self.exterior:GetData("locked") then
			if IsValid(a) and a:IsPlayer() then
				if self.exterior:CallHook("LockedUse",a)==nil then
                    TARDIS:Message(a, "The doors are locked.")
				end
				self:EmitSound(self.exterior.metadata.Exterior.Sounds.Door.locked)
			end
		else
			if a:KeyDown(IN_WALK) then
				if self.ExteriorPart then
					self.exterior:PlayerEnter(a)
				else
					self.exterior:PlayerExit(a)
				end
			else
				if (self.exterior:GetData("repair-primed",false) or self.exterior:GetData("repairing",false)) and self.ExteriorPart then return end
				self.exterior:ToggleDoor()
			end
		end
	end
	
	hook.Add("SkinChanged", "tardisi-door", function(ent,i)
		if ent.TardisExterior then
			local door=ent:GetPart("door")
			if IsValid(door) then
				door:SetSkin(i)
			end
			if IsValid(ent.interior) then
				local door=ent.interior:GetPart("door")
				if IsValid(door) then
					door:SetSkin(i)
				end
			end
		end
	end)
else
	function PART:Initialize()
		self.DoorPos=0
		self.DoorTarget=0
	end
	
	function PART:Think()
		if self.ExteriorPart then
			self.DoorTarget=self.exterior.DoorOverride or (self.exterior:GetData("doorstatereal",false) and 1 or 0)
			
			-- Have to spam it otherwise it glitches out (http://facepunch.com/showthread.php?t=1414695)
			self.DoorPos=self.exterior.DoorOverride or math.Approach(self.DoorPos,self.DoorTarget,FrameTime()*(1/self.exterior.metadata.Exterior.DoorAnimationTime))
			
			self:SetPoseParameter("switch", self.DoorPos)
			self:InvalidateBoneCache()
		elseif self.InteriorPart then -- copy exterior, no need to redo the calculation
			local door=self.exterior:GetPart("door")
			if IsValid(door) then
				self:SetPoseParameter("switch", door.DoorPos)
				self:InvalidateBoneCache()
			end
		end
	end
end

TARDIS:AddPart(PART)