-- Metadata

ENT:AddHook("Initialize", "metadata", function(self)
    self.phys:SetMass(self:GetMetadata().Exterior.Mass)
end)