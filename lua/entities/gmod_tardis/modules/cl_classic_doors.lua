ENT:AddHook("ShouldDraw", "classic_doors_exterior", function(self)
	if self.metadata.EnableClassicDoors
		and wp.drawing and wp.drawingent == self.interior.portals.interior
	then
		return false
	end

end)

ENT:AddHook("ShouldDrawPart", "classic_doors_exterior_door", function(self, part)
	if self.metadata.EnableClassicDoors == true and part ~= nil
		and wp.drawing and wp.drawingent == self.interior.portals.interior
		and part == TARDIS:GetPart(self, "door")
	then
		return false
	end
end)

ENT:AddHook("PlayerEnter", "classic_doors_intdoor_sound", function(self,ply,notp)
	if not IsValid(self.interior) then return end
	if self.metadata.EnableClassicDoors ~= true then return end
	if self.metadata.NoSoundOnEnter == true then return end

	local intdoor = TARDIS:GetPart(self.interior, "intdoor")
	if not IsValid(intdoor) then return end

	local door_sounds = self.metadata.Interior.Sounds.Door
	if not door_sounds then return end

	local door_sound = self:GetData("doorstatereal") and door_sounds.open or door_sounds.close
	if not door_sound then return end

	if intdoor.IntDoorPos ~= nil and intdoor.IntDoorPos ~= 0 and intdoor.IntDoorPos ~= 1 then
		sound.Play(door_sound, self.interior:LocalToWorld( self.metadata.Interior.Fallback.pos ))
	end
end)
