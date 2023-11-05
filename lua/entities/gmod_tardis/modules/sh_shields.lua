function ENT:GetShieldsMax()
    local ratio = TARDIS:GetSetting("health_to_shields_ratio")
    return math.max(1, (1 - ratio) * TARDIS:GetSetting("health_max"))
end

function ENT:GetShieldsLevel()
    return self:GetData("shields_val")
end

function ENT:GetShieldsPercent()
    local val = self:GetShieldsLevel()
    local percent = (val * 100)/self:GetShieldsMax()
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

if SERVER then
    function ENT:SetShieldsLevel(value, force)
        if not self:GetShieldsOn() and not force then return end

        local MaxShields = self:GetShieldsMax()
        value = math.Clamp(value, 0 , MaxShields)
        if self:GetData("shields_val") > value then
            self:SetData("shields_last_hit", CurTime())
        end
        self:SetData("shields_val", value, true)
    end

    function ENT:AddShieldsLevel(value, force)
        if not self:GetShieldsOn() and not force then return end

        local CurrentShields = self:GetData("shields_val", 0)
        self:SetShieldsLevel(CurrentShields + value, force)
    end

    ENT:AddHook("Initialize", "shields", function(self)
        local max = self:GetShieldsMax()
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
        if self:CallCommonHook("ShouldRegenShields") == false then return end
        if CurTime() < self:GetData("shields_last_hit", 0) + 10 then return end
        if CurTime() < self:GetData("shields_regen_time", 0) then return end

        self:SetData("shields_regen_time", CurTime() + 0.75)
        self:AddShieldsLevel(self:GetShieldsMax() * 0.01)
    end)

    ENT:AddHook("ShouldRegenShields", "shields", function(self)
        if not self:GetShieldsOn() then
            return false
        end
    end)

    ENT:AddHook("OnHealthDepleted", "shields", function(self)
        self:SetShieldsLevel(0,true)
    end)

    ENT:AddHook("SettingChanged", "shields", function(self, id, val)
        if id ~= "health_to_shields_ratio" then return end

        self:ChangeHealth(self:GetHealth())
        self:SetShieldsLevel(self:GetShieldsLevel())
    end)
end


