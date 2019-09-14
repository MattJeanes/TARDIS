--Security System (Isomorphic)

function ENT:GrantPermission(ply, type)
    --accepted types:
    local types = {"parts", "doors", "enter", "screens"}
    if not table.HasValue(types, type) then
        error("Permission type is invalid")
        return
    end
    local permstable = self:GetData("security-perms",{})
    if not permstable[ply:SteamID64()] then
        permstable[ply:SteamID64()] = {}
    end
    permstable[ply:SteamID64()][type] = true
    self:SetData("security-perms",permstable,true)
end
function ENT:RevokePermission(ply, type)
    --accepted types:
    local types = {"parts", "doors", "enter", "screens"}
    if not table.HasValue(types, type) then
        error("Permission type is invalid")
        return
    end
    local permstable = self:GetData("security-perms",{})

    permstable[ply:SteamID64()][type] = false
    self:SetData("security-perms",permstable,true)
end

function ENT:UpdatePlayerPerms(ply)
    local permstable = self:GetData("security-perms",{})
    local sid64 = ply:SteamID64()
    ply:SetTardisData("can-use-parts",permstable[sid64]["parts"])
    ply:SetTardisData("can-use-doors",permstable[sid64]["doors"])
    ply:SetTardisData("can-enter-tardis",permstable[sid64]["enter"])
    ply:SetTardisData("can-use-screens",permstable[sid64]["screens"])
end
--Hooks

ENT:AddHook("Initialize", "security", function(self)
    self:GrantPermission(self.owner, "parts")
    self:SetData("ism-on",true)
end)

ENT:AddHook("PlayerEnter", "isomorphic", function(self, ply)
    self:UpdatePlayerPerms(ply)
end)