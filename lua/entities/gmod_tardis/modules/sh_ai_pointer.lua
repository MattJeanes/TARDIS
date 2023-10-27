ENT:AddHook("Initialize","ai_pointer",function(self)
	if CLIENT then return end
	local ent = ents.Create("gmod_tardis_ai_point")
	local ply = self:GetCreator()

	ent:SetCreator(ply)

	ent.tardis = self
	self.ai_point = ent

	ent:Spawn()
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:SetParent(self)

	gamemode.Call("PlayerSpawnedSENT",ply,ent)
	ply:AddCleanup("sents",ent)
end)

ENT:AddHook("OnRemove", "ai_pointer", function(self)
	if IsValid(self.ai_point) then
		self.ai_point:Remove()
	end
end)
