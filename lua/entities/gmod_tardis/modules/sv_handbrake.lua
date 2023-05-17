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

ENT:AddHook("HandbrakeToggled", "vortex", function(self, on)
    if on and self:GetData("teleport") or self:GetData("vortex") then
        self:InterruptTeleport()
    else
        self:InterruptFlight()
    end
end)

ENT:AddHook("CanTurnOnFlight", "handbrake", function(self)
    if self:GetData("handbrake") then
        return false
    end
end)
