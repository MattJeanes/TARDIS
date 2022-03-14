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
    --if self.metadata.EnableClassicDoors ~= true then return end
    if self.metadata.NoSoundOnEnter == true then return end

    local intdoor = TARDIS:GetPart(self.interior, "intdoor")
    if not IsValid(intdoor) then return end

    local sounds = self.metadata.Interior.Sounds
    local door_sounds = sounds.IntDoor or sounds.Door
    if not door_sounds then return end

    local doorstatereal = self:GetData("doorstatereal")
    local door_sound = doorstatereal and door_sounds.open or door_sounds.close
    if not door_sound then return end

    local doorpos = intdoor.IntDoorPos
    local fallback_pos = self.metadata.Interior.Fallback.pos
    if doorpos ~= nil and doorpos ~= 0 and doorpos ~= 1 then
        sound.Play(door_sound, self.interior:LocalToWorld(fallback_pos))
    end
end)
