include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    local id = net.ReadString()
    if net.ReadBool() then
        self.templates = TARDIS.von.deserialize(net.ReadString())
        if self.interior then
            self.interior.templates = self.templates
        end
    end

    self.metadata=TARDIS:CreateInteriorMetadata(id, self)
end)