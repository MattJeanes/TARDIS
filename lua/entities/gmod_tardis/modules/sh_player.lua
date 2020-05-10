if SERVER then
	ENT:AddHook("StopMat", "player-enterontp", function(self)
		local min, max = self:GetCollisionBounds()
		min = self:LocalToWorld(min)
		max = self:LocalToWorld(max)
		local entities = ents.FindInBox(min, max)
		if #entities != 0 then
			for k,v in pairs(entities) do
				if v:IsPlayer() then
					self:PlayerEnter(v)
				end
			end
		end
	end)
end
