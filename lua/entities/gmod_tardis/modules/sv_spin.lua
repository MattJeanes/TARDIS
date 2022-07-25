-- Spin

ENT:AddHook("Initialize", "spin", function(self)
    self:SetData("spindir", -1)
    self:SetData("spindir_prev", 0)
end)

function ENT:ToggleSpin()
    local current = self:GetData("spindir", -1)
    local prev = self:GetData("spindir_prev", 0)

    self:SetData("spindir_prev", current)
    self:SetData("spindir", prev)
end

function ENT:CycleSpinDir()
    local current = self:GetData("spindir", -1)
    local prev = self:GetData("spindir_prev", 0)

    self:SetData("spindir_prev", current)
    self:SetData("spindir", -prev)
end

function ENT:SwitchSpinDir()
    local current = self:GetData("spindir", -1)
    local prev = self:GetData("spindir_prev", 0)

    self:SetData("spindir_prev", -prev)
    self:SetData("spindir", -current)
end

function ENT:GetSpinDir()
    return self:GetData("spindir", -1)
end

function ENT:SetSpinDir(dir)
    return self:SetData("spindir", dir)
end

function ENT:GetSpinDirText(show_next)
    local current = self:GetData("spindir", -1)
    if show_next == true then
        current = self:GetData("spindir_prev", 0)
    end

    local text
    if current == -1 then
        text = "Spin.Directions.AntiClockwise"
    elseif current == 0 then
        text = "Spin.Directions.None"
    elseif current == 1 then
        text = "Spin.Directions.Clockwise"
    end

    return TARDIS:GetPhrase(text)
end

ENT:AddHook("ToggleDoorReal", "spin-dir", function(self,open)
    if TARDIS:GetSetting("opened-door-no-spin", self) then
        local current = self:GetData("spindir", -1)
        local before = self:GetData("spindir_before_door", nil)

        if open and self:GetSpinDir() ~= 0 then
            self:SetData("spindir_before_door", current)
            self:SetData("spindir_prev", current)
            self:SetData("spindir", 0)
        elseif not open and self:GetSpinDir() == 0 and before ~= nil then
            self:SetData("spindir_before_door", nil)
            self:SetData("spindir_prev", current)
            self:SetData("spindir", before)
        end
    end
end)