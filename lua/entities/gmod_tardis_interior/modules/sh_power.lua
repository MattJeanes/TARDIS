-- Power Module - courtesy of Win (shameless self promotion)

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
        self:SendMessage("power-toggled")
        self:CallHook("PowerToggled",on)
        self.exterior:CallHook("PowerToggled",on)
    end
else
    ENT:OnMessage("power-toggled", function(self)
        local state = self:GetData("power-state") or false
        if TARDIS:GetSetting("sound") then
            local sound_on = self.metadata.Interior.Sounds.Power.On
            local sound_off = self.metadata.Interior.Sounds.Power.Off
            if TARDIS:GetExteriorEnt() == self.exterior then
                if not TARDIS:GetSetting("sound") then return end
                self:EmitSound(state and sound_on or sound_off)
            end
            if self.idlesounds then
                if state == false then
                    for _,v in pairs(self.idlesounds) do
                        v:Stop()
                    end
                else
                    for _,v in pairs(self.idlesounds) do
                        v:Play()
                    end
                end
            end
        end
    end)
end