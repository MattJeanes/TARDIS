-- Metadata

ENT:AddHook("Initialize", "metadata", function(self)
    self.phys:SetMass(self.metadata.Exterior.Mass)
end)