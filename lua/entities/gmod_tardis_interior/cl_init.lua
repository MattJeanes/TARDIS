include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:GetInterior(net.ReadString(), self)

    self.Model=self:GetIntMetadata().Model
    self.Fallback=self:GetIntMetadata().Fallback
    self.Portal=self:GetIntMetadata().Portal
    self.ExitDistance=self:GetIntMetadata().ExitDistance
end)

