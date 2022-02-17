-- Idle sound

TARDIS:AddSetting({
    id="external_hum",
    name="External Hum",
    desc="Whether the hum on the outside of the TARDIS can be heard if it exists",
    section="Sounds",
    value=true,
    type="bool",
    option=true
})

ENT:AddHook("OnRemove", "externalhum", function(self)
    if self.ExternalHum then
        self.ExternalHum:Stop()
        self.ExternalHum = nil
    end
end)

ENT:AddHook("Think", "externalhum", function(self)
    local hum_sound = self.metadata.Exterior.Sounds.Hum
    if hum_sound then
        if TARDIS:GetSetting("external_hum") and TARDIS:GetSetting("sound") and self:GetData("power-state", false) then
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