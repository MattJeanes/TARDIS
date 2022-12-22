-- Handbrake

ENT:AddHook("Initialize","handbrake-init", function(self)
    self:SetData("handbrake", false, true)
end)

function ENT:ToggleHandbrake()
    return self:SetHandbrake(not self:GetData("handbrake"))
end
function ENT:SetHandbrake(on)
    if self:CallCommonHook("CanToggleHandbrake") == false then
        return false
    end
    self:SetData("handbrake", on, true)
    self:CallCommonHook("HandbrakeToggled", on)
    return true
end

ENT:AddHook("ShouldFailDemat", "handbrake", function(self, force)
    if self:GetData("handbrake") and force ~= true then
        return true
    end
end)

ENT:AddHook("HandbrakeToggled", "vortex", function(self, force)
    if self:GetData("handbrake") then
        if self:GetData("teleport") or self:GetData("vortex") then
            self:InterruptTeleport()
        end
    end
end)

ENT:AddHook("HandbrakeToggled", "flight", function(self, force)
    if self:GetData("handbrake") then
        if self:GetData("flight") then
            self:ToggleFlight()
            self:Explode()
            if IsValid(self.interior) then
                self.interior:Explode()
            end
        end
    end
end)

ENT:AddHook("CanTurnOnFlight", "handbrake", function(self)
    if self:GetData("handbrake") then
        return false
    end
end)
