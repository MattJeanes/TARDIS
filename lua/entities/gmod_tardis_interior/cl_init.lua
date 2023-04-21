include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    local id = net.ReadString()
    if net.ReadBool() then
        self.templates = TARDIS.von.deserialize(net.ReadString())
        if self.exterior then
            self.exterior.templates = self.templates
        end
    end

    self.metadata=TARDIS:CreateInteriorMetadata(id, self)

    self.Model=self.metadata.Interior.Model
    self.Fallback=self.metadata.Interior.Fallback
    self.Portal=self.metadata.Interior.Portal
    self.ExitDistance=self.metadata.Interior.ExitDistance
end)

