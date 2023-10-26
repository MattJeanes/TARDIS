function ENT:GetMaxShields()
    return TARDIS:GetSetting("health-max")
end
if SERVER then
    function ENT:SetShieldsLevel(value)
        local MaxShields = self:GetMaxShields()-- change to shields_max in future --
        value = math.Clamp(value, 0 , MaxShields)
        if self:GetData("shields_val") > value then
            self:SetData("shields_last_hit", CurTime())
        end
        self:SetData("shields_val", value, true)
    end

    function ENT:AddShieldsLevel(value)
        local CurrentShields = self:GetData("shields_val", 0)
        self:SetShieldsLevel(CurrentShields + value)
    end

    ENT:AddHook("Initialize", "shields", function(self)
        local max = self:GetMaxShields()
        self:SetData("shields_val", max, true)
        self:SetData("shields_on", true, true)
    end)

    function ENT:SetShieldsOn(on)
        if self:CallCommonHook("CanToggleShields", on) == false then
            return false
        end
        self:SetData("shields_on", on, true)
        self:CallCommonHook("ShieldsToggled", on)
        return true
    end

    function ENT:ToggleShields()
        return self:SetShieldsOn(not self:GetShieldsOn())
    end

    ENT:AddHook("Think", "shields", function(self)
        if CurTime() - 10 < self:GetData("shields_last_hit", 0) then return end

        if CurTime() < self:GetData("shields_regen_time", 0) then return end
        self:SetData("shields_regen_time", CurTime() + 1)
        self:AddShieldsLevel(self:GetMaxShields() * 0.01)
    end)
end

function ENT:GetShieldsLevel()
    return self:GetData("shields_val")
end

function ENT:GetShieldsPercent()
    local val = self:GetShieldsLevel()
    local percent = (val * 100)/self:GetMaxShields()
    return percent
end

function ENT:GetShieldsOn()
    return self:GetData("shields_on")
end

function ENT:GetShields()
    if not self:GetShieldsOn() or self:GetShieldsLevel() <= 0 then
        return false
    end
    return self:GetShieldsLevel()
end