-- Rotorwash

function ENT:CreateRotorWash()
    if IsValid(self.rotorwash) then return end
    self.rotorwash = ents.Create("env_rotorwash_emitter")
    self.rotorwash:SetPos(self:GetPos())
    self.rotorwash:SetParent(self)
    self.rotorwash:Activate()
end

function ENT:RemoveRotorWash()
    if IsValid(self.rotorwash) then
        self.rotorwash:Remove()
        self.rotorwash=nil
    end
end

ENT:AddHook("Think", "rotorwash", function(self)
    local shouldon=self:CallHook("ShouldTurnOnRotorwash")
    local shouldoff=self:CallHook("ShouldTurnOffRotorwash")

    if shouldon and (not shouldoff) then
        if not self.rotorwash then
            self:CreateRotorWash()
        end
    elseif self.rotorwash then
        self:RemoveRotorWash()
    end
end)