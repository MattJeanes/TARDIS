-- Parts

ENT:AddHook("Initialize","parts",function(self)
	if SERVER then
		TARDIS:SetupParts(self)
	elseif self.partqueue then
		for k,v in pairs(self.partqueue) do
			TARDIS:SetupPart(k,v,self.exterior,self,self)
		end
	end
end)

ENT:AddHook("Cordon","parts",function(self,class,ent)
	if ent.TardisPart then return false end
end)

function ENT:GetPart(id)
	return self.parts and self.parts[id] or NULL
end