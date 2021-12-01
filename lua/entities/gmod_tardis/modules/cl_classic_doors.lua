local function SetVisibleIfExists(part, visible)
	if part ~= nil and part ~= NULL then
		if visible then
			part:SetColor(Color(255,255,255,255))
			part:SetRenderMode(RENDERMODE_NORMAL)
		else
			part:SetRenderMode(RENDERMODE_TRANSALPHA)
			part:SetColor(Color(0,0,0,0))
		end
	end
end

ENT:AddHook("Think", "classic_doors", function(self)
	if self.metadata.EnableClassicDoors ~= true then return end

	local door = TARDIS:GetPart(self,"door")
	local door_mirror = TARDIS:GetPart(self.interior,"door")
	local intdoor = TARDIS:GetPart(self.interior,"intdoor")
	local ply = LocalPlayer()

	if ply:GetTardisData("exterior") == self
		and not ply:GetTardisData("thirdperson")
		and not ply:GetTardisData("destination")
	then
		SetVisibleIfExists(self, false)
		SetVisibleIfExists(door, false)
		SetVisibleIfExists(door_mirror, false)
		SetVisibleIfExists(intdoor, true)
	else
		SetVisibleIfExists(self, true)
		SetVisibleIfExists(door, true)
		SetVisibleIfExists(door_mirror, true)
		SetVisibleIfExists(intdoor, false)
	end
end)