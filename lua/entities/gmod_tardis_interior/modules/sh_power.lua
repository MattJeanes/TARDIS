-- Power Interior

if SERVER then
    function ENT:TogglePower()
        self.exterior:TogglePower()
    end

    function ENT:SetPower(on)
        self.exterior:SetPower(on)
    end

    ENT:AddHook("PowerToggled", "interior-power", function(self, state)
        self:SendMessage("power-toggled", function()
            net.WriteBool(state)
        end)
    end)
else
    ENT:OnMessage("power-toggled", function(self)
        local state = net.ReadBool()
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