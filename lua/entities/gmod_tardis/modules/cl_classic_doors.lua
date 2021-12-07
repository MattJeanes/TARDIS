ENT:AddHook("ShouldDraw", "classic_doors_support", function(self)
	if self.metadata.EnableClassicDoors ~= true then return end

	local ply = LocalPlayer()

	local inside = (ply:GetTardisData("exterior") == self
		and not ply:GetTardisData("thirdperson")
		and not ply:GetTardisData("destination"))

	if inside then return false end

end)

ENT:AddHook("ShouldDrawPart", "classic_doors_support", function(self, part)
	if self.metadata.EnableClassicDoors ~= true then return end
	if part == nil then return end

	local ply = LocalPlayer()

	local inside = (ply:GetTardisData("exterior") == self
		and not ply:GetTardisData("thirdperson")
		and not ply:GetTardisData("destination"))

	if part == TARDIS:GetPart(self,"door") then
		if inside then
			return false
		end
	end
end)