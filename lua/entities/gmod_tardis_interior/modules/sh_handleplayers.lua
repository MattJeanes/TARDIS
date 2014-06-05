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
		self.exterior:PlayerExit(a)
	end)
end