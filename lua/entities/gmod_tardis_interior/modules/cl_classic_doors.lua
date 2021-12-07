ENT:AddHook("ShouldDrawPart", "classic_doors_support", function(self, part)
	if self.metadata.EnableClassicDoors ~= true then return end
	if part == nil then return end

	local ply = LocalPlayer()

	local inside = (ply:GetTardisData("interior") == self
		and not ply:GetTardisData("thirdperson")
		and not ply:GetTardisData("destination"))

	if inside and part == TARDIS:GetPart(self, "door") then
		return false
	end
	if not inside and part == TARDIS:GetPart(self, "intdoor") then
		return false
	end

end)