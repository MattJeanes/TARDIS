ENT:AddHook("Think", "dodo_tardis_mat", function(self)
	if self:GetData("teleport") then
		for k,v in pairs(player.GetAll()) do
			if (self:GetPos():Distance(v:GetPos()) < 45) then
				self:PlayerEnter(v)
				if IsValid(self.interior) then
					util.ScreenShake(self.interior:GetPos(), 5, 5, 3, 5000)
				end	
			end
		end			
	end
end)
