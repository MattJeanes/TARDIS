-- Security System (Isomorphic)

function ENT:GetSecurity()
    return self:GetData("security", false)
end

function ENT:CheckSecurity(ply)
    return (not self:GetSecurity()) or (ply==self:GetCreator())
end

if SERVER then
    function ENT:SetSecurity(on)
        self:CallHook("SecurityToggled", on)
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
    if (not part.BypassIsomorphic) and (not self:CheckSecurity(ply)) then
        TARDIS:Message(ply, "Security.ControlUseDenied")
        return false,false
    end
end)

ENT:AddHook("CanUseTardisControl", "security", function(self, control, ply)
    if (not control.bypass_isomorphic) and (not self:CheckSecurity(ply)) then
        TARDIS:Message(ply, "Security.ControlUseDenied")
        return false
    end
end)

ENT:AddHook("CanChangePilot", "flight", function(self, ply)
    if not self:CheckSecurity(ply) then
        return false
    end
end)

ENT:AddHook("HandleE2", "security", function(self,name,e2)
    if IsValid(self.interior) then
        if name == "Isomorph" and TARDIS:CheckPP(e2.player, self) then
            return self.interior:ToggleSecurity() and 1 or 0
        elseif name == "GetIsomorphic" then
            return self.interior:GetSecurity() and 1 or 0
        end
    else
        if name == "Isomorph" or name == "GetIsomorphic" then
            return 0
        end
    end
end)
