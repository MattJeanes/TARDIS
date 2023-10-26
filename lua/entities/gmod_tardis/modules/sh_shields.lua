if SERVER then
    function ENT:SetShieldsLevel(value)
        local MaxShields = TARDIS:GetSetting("health-max")-- change to shields_max in future --
        value = math.Clamp(value, 0 , MaxShields)
        self:SetData("shields_val", value, true)
    end

    function ENT:AddShieldsLevel(value)
        local CurrentShields = self:GetData("shields_val", 0)
        self:SetShieldsLevel(CurrentShields + value)
    end

    ENT:AddHook("Initialize", "shields", function(self)
        local max = TARDIS:GetSetting("health-max")
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
end

function ENT:GetShieldsLevel()
    return self:GetData("shields_val")
end

function ENT:GetShieldsPercent()
    local val = self:GetShieldsLevel()
    local percent = (val * 100)/TARDIS:GetSetting("health-max")
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