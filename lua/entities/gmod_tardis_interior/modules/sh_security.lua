-- Security System (Isomorphic)

function ENT:GetSecurity()
    return self.exterior:GetSecurity()
end

function ENT:CheckSecurity(ply)
    return self.exterior:CheckSecurity(ply)
end

if SERVER then
    function ENT:SetSecurity(on)
        return self.exterior:SetSecurity(on)
    end

    function ENT:ToggleSecurity()
        return self.exterior:ToggleSecurity()
    end
end

ENT:AddHook("CanUsePart","security",function(self,part,ply)
    if not self:CheckSecurity(ply) and not part.BypassIsomorphic then
        TARDIS:Message(ply, "Security.ControlUseDenied")
        return false,false
    end
end)

if CLIENT then
    ENT:AddHook("ShouldDrawTips", "security", function(self)
        if not self:CheckSecurity(LocalPlayer()) then
            return false
        end
    end)
end
