-- Security System (Isomorphic)

function ENT:GetSecurity()
    return self:GetData("security", false)
end

if SERVER then
    function ENT:SetSecurity(on)
        return self:SetData("security", on, true)
    end

    function ENT:ToggleSecurity()
        self:SetSecurity(not self:GetSecurity())
        return true
    end
end

-- Hooks

ENT:AddHook("Initialize","security", function(self)
    if not self:GetData("security") then
        self:SetData("security", TARDIS:GetSetting("security", self), true)
    end
end)

ENT:AddHook("CanUsePart","security",function(self,part,ply)
    if self:GetSecurity() and (ply~=self:GetCreator()) then
        if part.BypassIsomorphic then return end
        TARDIS:Message(ply, "Security.PartUseDenied")
        return false,false
    end
end)
