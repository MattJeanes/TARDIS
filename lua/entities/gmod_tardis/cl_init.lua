include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:GetInterior(net.ReadString())
    self.metadata = TARDIS:MergeInteriorTemplates(self.metadata, true, self:GetCreator(), self)
end)