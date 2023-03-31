-- Power Exterior

TARDIS:AddKeyBind("power",{
    name="Power",
    section="ThirdPerson",
    func=function(self,down,ply)
        if down and ply == self.pilot then
            TARDIS:Control("power", ply)
        end
    end,
    key=KEY_P,
    serveronly=true,
    exterior=true
})

ENT:AddHook("Initialize","power-init", function(self)
    self:SetData("power-state",true,true)
end)

function ENT:GetPower()
    return self:GetData("power-state", false)
end

ENT:AddHook("CanUseTardisControl", "power", function(self, control, ply)
    if not self:GetPower() and not control.power_independent then
        TARDIS:ErrorMessage(ply, "Common.PowerDisabledControl")
        return false
    end
end)

if SERVER then
    function ENT:TogglePower()
        return self:SetPower(not self:GetPower())
    end
    function ENT:SetPower(on)
        if (self:CallCommonHook("CanTogglePower") == false) then return false end
        self:SetData("power-state",on,true)
        self:CallCommonHook("PowerToggled", on)
        self:SendMessage("power_toggled", {on})
        return true
    end

    ENT:AddHook("CanTogglePower", "vortex", function(self)
        if self:GetData("teleport") or self:GetData("vortex") then
            return false
        end
    end)

    ENT:AddHook("CanTriggerHads","power",function(self)
        if not self:GetPower() then return false end
    end)

    ENT:AddHook("HandleE2", "power", function(self,name,e2)
        if name == "Power" and TARDIS:CheckPP(e2.player, self) then
            local part = TARDIS:GetPartByAction(self.interior, "power")
            if part ~= nil then
                TARDIS:UsePart(part)
            end
            return self:TogglePower() and 1 or 0
        elseif name == "GetPowered" then
            return self:GetPower() and 1 or 0
        end
    end)
else
    ENT:AddHook("ShouldNotDrawProjectedLight", "power", function(self)
        if not self:GetPower() then return true end
    end)

    ENT:AddHook("ShouldTurnOffLight", "power", function(self)
        if not self:GetPower() then return true end
    end)

    ENT:OnMessage("power_toggled", function(self, data, ply)
        local on = data[1]
        self:CallCommonHook("PowerToggled", on)
    end)
end