-- Vortex flight related functions

ENT:AddHook("StopDemat", "no_vortex", function(self)
    if self:GetData("demat-fast",false) then
        self:Timer("fastremat", 0.3, function()
            if not IsValid(self) then return end
            self:Mat()
        end)
    end
end)

function ENT:ToggleFastRemat()
    if self:CallHook("CanToggleFastRemat") ~= false then
        local on = not self:GetData("demat-fast",false)
        return self:SetFastRemat(on)
    end
end

function ENT:SetFastRemat(on)
    self:SetData("demat-fast",on,true)
    self:CallHook("FastRematToggled", on)
    return true
end

ENT:AddHook("CanToggleFastRemat", "vortex", function(self)
    if self:GetData("vortex",false) then
        return false
    end
end)

ENT:AddHook("ShouldStopSmoke", "vortex", function(self)
    if self:GetData("vortex") then return true end
end)

ENT:AddHook("ShouldTakeDamage", "vortex", function(self)
    if self:GetData("vortex",false) then return false end
end)

ENT:AddHook("ShouldTurnOffRotorwash", "vortex", function(self)
    if self:GetData("vortex") then
        return true
    end
end)
