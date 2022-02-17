include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:GetInterior(net.ReadString(), self)
end)