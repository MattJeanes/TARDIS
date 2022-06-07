include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:GetInterior(net.ReadString(), self)

    self.Model=self:GetMetadata().Interior.Model
    self.Fallback=self:GetMetadata().Interior.Fallback
    self.Portal=self:GetMetadata().Interior.Portal
    self.ExitDistance=self:GetMetadata().Interior.ExitDistance
end)

