-- Power Module - courtesy of Win (shameless self promotion)

ENT:AddHook("Initialize","power-init", function(self)
    self:SetData("power-state",true,true)
end)
if SERVER then
    function ENT:DisablePower()
        if self:GetData("power-state")==false then return end
        self:SetData("power-state", false,true) 
        self:SendMessage("power-toggled")
    end

    function ENT:EnablePower()
        if self:GetData("power-state")==true then return end
        self:SetData("power-state", true,true) 
        self:SendMessage("power-toggled")
    end

else
    ENT:OnMessage("power-toggled", function(self)
        local state = self:GetData("power-state") or false
        if TARDIS:GetSetting("sound") then
            local sound_on = self.metadata.Interior.Sounds.Power.On
            local sound_off = self.metadata.Interior.Sounds.Power.Off
            if LocalPlayer():GetTardisData("exterior") == self.exterior then
                self:EmitSound(state and sound_on or sound_off)
            end
            if self.idlesounds then
                if state == false then
                    for k,v in pairs(self.idlesounds) do
                        v:Stop()
                    end
                else
                    for k,v in pairs(self.idlesounds) do
                        v:Play()
                    end
                end
            end
        end
    end)
end