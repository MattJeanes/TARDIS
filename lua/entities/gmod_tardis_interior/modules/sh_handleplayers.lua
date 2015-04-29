// Handles players inside the tardis interior

if SERVER then
	ENT:AddHook("Think", "handleplayers", function(self)
		local pos=self:GetPos()
		for k,v in pairs(self.occupants) do
			if k:GetPos():Distance(pos) > 600 then
				self.exterior:PlayerExit(k,true)
			end
		end
	end)
else
	ENT:AddHook("ShouldDraw", "players", function(self)
		if LocalPlayer():GetNetEnt("tardis_i")==self and not wp.drawing and not LocalPlayer():GetTardisData("thirdperson") then
			return true
		end
	end)
	ENT:AddHook("ShouldThink", "players", function(self)
		if LocalPlayer():GetNetEnt("tardis_i")==self then
			return true
		end
	end)
end