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