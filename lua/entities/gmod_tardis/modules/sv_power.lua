-- Power Exterior

ENT:AddHook("Initialize","power-init", function(self)
    self:SetData("power-state",true,true)
end)

if SERVER then
    function ENT:TogglePower()
        local on = not self:GetData("power-state",false)
        self:SetPower(on)
    end
    function ENT:SetPower(on)
        if not (self:CallHook("CanTogglePower")==true or self.exterior:CallHook("CanTogglePower")==true) then return end
        self:SetData("power-state",on,true)
        --self:SendMessage("power-toggled")
        self:CallHook("PowerToggled",on)
        if self.interior then
            self.interior:CallHook("PowerToggled",on)
        end
    end
end