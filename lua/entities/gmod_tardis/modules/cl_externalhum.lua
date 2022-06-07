-- Idle sound

ENT:AddHook("OnRemove", "externalhum", function(self)
    if self.ExternalHum then
        self.ExternalHum:Stop()
        self.ExternalHum = nil
    end
end)

ENT:AddHook("Think", "externalhum", function(self)
    local hum_sound = self:GetExtMetadata().Sounds.Hum
    if hum_sound then
        if TARDIS:GetSetting("external_hum") and TARDIS:GetSetting("sound") and self:GetData("power-state") then
            if not self.ExternalHum then
                self.ExternalHum = CreateSound(self, hum_sound.path)
                self.ExternalHum:Play()
                self.ExternalHum:ChangeVolume(hum_sound.volume or 1,0)
            end
        elseif self.ExternalHum then
            self.ExternalHum:Stop()
            self.ExternalHum=nil
        end
    end
end)