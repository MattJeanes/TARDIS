// Handles players inside the tardis interior

if SERVER then
	ENT:AddHook("Think", "handleplayers", function(self)
		local pos=self:GetPos()
		for k,v in pairs(self.occupants) do
			if v:GetPos():Distance(pos) > 600 then
				self.exterior:PlayerExit(v,true)
			end
		end
	end)
	
	ENT:AddHook("Use", "handleplayers", function(self,a,c)
		if a:KeyDown(IN_WALK) then
			self.exterior:PlayerExit(a)
		end
	end)
else
	ENT:AddHook("ShouldDraw", "players", function(self)
		if LocalPlayer():GetNetEnt("tardis_i")==self and not wp.drawing then
			return true
		end
	end)
	ENT:AddHook("ShouldThink", "players", function(self)
		if LocalPlayer():GetNetEnt("tardis_i")==self then
			return true
		end
	end)
end