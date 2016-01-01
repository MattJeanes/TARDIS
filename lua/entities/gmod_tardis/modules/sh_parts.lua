-- Parts

if SERVER then
	ENT:AddHook("Initialize","parts",function(self)
		TARDIS:SetupParts(self)
	end)
end

function ENT:GetPart(id)
	return self.parts and self.parts[id] or NULL
end