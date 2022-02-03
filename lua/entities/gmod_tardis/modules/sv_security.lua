--Exterior security

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

ENT:AddHook("CanChangePilot", "flight", function(self, ply)
    if ply~=self:GetCreator() and self.interior and self.interior:GetSecurity() then
        return false
    end
end)