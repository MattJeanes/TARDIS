local PART={}
PART.ID = "intdoor"
PART.Name = "Interior Doors"
PART.Model = "models/drmatt/tardis/exterior/door.mdl"
PART.AutoSetup = true
PART.AutoPosition = true
PART.ClientThinkOverride = true
PART.Collision = false
PART.NoStrictUse = true
PART.ShouldTakeDamage = true
PART.BypassIsomorphic = true


if SERVER then
	function PART:Use(a)

		if self.exterior:GetData("locked") then
			if IsValid(a) and a:IsPlayer() then
				if self.exterior:CallHook("LockedUse",a)==nil then
					TARDIS:Message(a, "The doors are locked.")
				end
			end
		else
			if a:KeyDown(IN_WALK) then
				self.exterior:PlayerExit(a)
			end
		end
	end
else

	function PART:Initialize()
		self.IntDoorPos=0
		self.IntDoorTarget=0
	end

	function PART:Think()
		self.IntDoorTarget=self.exterior.IntDoorOverride or (self.exterior:GetData("doorstatereal",false) and 1 or 0)
		local animtime = self.exterior.metadata.Interior.IntDoorAnimationTime
			or self.exterior.metadata.Exterior.DoorAnimationTime

		-- Have to spam it otherwise it glitches out (http://facepunch.com/showthread.php?t=1414695)
		self.IntDoorPos = self.exterior.IntDoorOverride or
			math.Approach(self.IntDoorPos, self.IntDoorTarget, FrameTime() * (1 / animtime))

		self:SetPoseParameter("switch", self.IntDoorPos)
		self:InvalidateBoneCache()

	end
end

TARDIS:AddPart(PART)