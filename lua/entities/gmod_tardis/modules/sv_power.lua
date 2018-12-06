ENT:AddHook("CanDemat", "power-disable", function(self)
    return self.interior:GetData("power-state") or false
end)

function ENT:TogglePower()
    self.interior:TogglePower()
end