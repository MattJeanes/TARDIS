include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:CreateInteriorMetadata(net.ReadString(), self)
end)