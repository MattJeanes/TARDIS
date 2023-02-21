-- Spacebuild

ENT:AddHook("Initialize", "spacebuild", function(self)
    if not (CAF and CAF.GetAddon("Spacebuild")) then
        return
    end

    self:SetData("spacebuild", true)
end)

ENT:AddHook("FloatToggled", "spacebuild", function(self, on)
    if not (self:GetData("spacebuild", false) and self.environment) then
        return
    end

    if not on then 
        self.gravity = nil
        self.environment:UpdateGravity(self)
    end
end)
