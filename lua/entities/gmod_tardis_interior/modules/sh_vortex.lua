-- Vortex

ENT:AddHook("ShouldTracePortal", "vortex", function(self,portal)
    if self:GetData("vortex",false) and portal==self.portals.interior then
        return false
    end
end)

ENT:AddHook("ShouldTeleportPortal", "vortex", function(self,portal)
    if self:GetData("vortex",false) and portal==self.portals.interior then
        return false
    end
end)