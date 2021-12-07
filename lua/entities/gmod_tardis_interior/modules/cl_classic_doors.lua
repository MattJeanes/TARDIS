ENT:AddHook("ShouldDrawPart", "classic_doors_intdoor", function(self, part)
	if self.metadata.EnableClassicDoors == true and part ~= nil
		and wp.drawing and wp.drawingent == self.portals.exterior
		and part == TARDIS:GetPart(self, "intdoor")
	then
		return false
	end
end)

ENT:AddHook("ShouldDrawPart", "classic_doors_door_mirror", function(self, part)
	if self.metadata.EnableClassicDoors == true and part ~= nil
		and part == TARDIS:GetPart(self, "door")
		and not (wp.drawing and wp.drawingent == self.portals.exterior)
	then
		return false
	end

end)