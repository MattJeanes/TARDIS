ENT:AddHook("CanDemat", "power-disable", function(self)
    if not self.interior:GetData("power-state",false) then
        return false
    end
end)

ENT:AddHook("CanTurnOnFlight", "power-disable", function(self)
    if not self.interior:GetData("power-state",false) then
        return false
    end
end)

function ENT:TogglePower()
    self.interior:TogglePower()
end