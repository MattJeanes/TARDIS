include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:GetInterior(net.ReadString())
    self.metadata = TARDIS:MergeInteriorTemplates(self.metadata, true, self:GetCreator())

    self.Model=self.metadata.Interior.Model
    self.Fallback=self.metadata.Interior.Fallback
    self.Portal=self.metadata.Interior.Portal
    self.ExitDistance=self.metadata.Interior.ExitDistance
end)