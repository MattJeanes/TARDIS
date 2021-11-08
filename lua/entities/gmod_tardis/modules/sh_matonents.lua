if SERVER then
	local convar = CreateConVar("tardis2_enteronmat", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "TARDIS - Move players inside when materialized on top of", 0, 1)

	ENT:AddHook("StopMat", "player-enterontp", function(self)
		if not convar:GetBool() then return end
		local min, max = self:GetCollisionBounds()
		min = self:LocalToWorld(min)
		max = self:LocalToWorld(max)
		local entities = ents.FindInBox(min, max)
		if #entities ~= 0 then
			for k,v in pairs(entities) do
				if v:IsPlayer() then
					self:PlayerEnter(v)
					v:ScreenFade(SCREENFADE.IN, Color(255,255,255,200), 1, 0.1)
				end
			end
		end
	end)

	ENT:AddHook("Think", "player-enterontp", function(self)
		if not convar:GetBool() then return end
		if not self:GetData("mat") then return end

		local min, max = self:GetCollisionBounds()
		min = self:LocalToWorld(min)
		max = self:LocalToWorld(max)
		local entities = ents.FindInBox(min, max)

		if #entities ~= 0 then
			for k,v in pairs(entities) do
				if v:IsPlayer() then
					v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, math.max(self:GetData("alpha", 255) - 30, 0)), 0.1, 0.1)
				end
			end
		end
	end)
end
