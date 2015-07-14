-- Interiors

ENT.Interiors={}
function ENT:AddInterior(t)
	if util.IsValidModel(t.Model) then
		self.Interiors[t.ID]=t
	end
end

function ENT:GetInterior(id)
	if self.Interiors[id]~= nil then
		return self.Interiors[id]
	end
end

function ENT:GetInteriors()
	return self.Interiors
end

ENT:LoadFolder("modules/interiors",nil,true)