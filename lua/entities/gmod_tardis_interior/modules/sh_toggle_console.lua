function ENT:GetConsoleEnabled()
    return self:GetData("console_on", true)
end

if SERVER then
    function ENT:SetConsoleEnabled(on)
        self:CallHook("ConsoleToggled", on)
        return self:SetData("console_on", on, true)
    end

    function ENT:ToggleConsole()
        return self:SetConsoleEnabled(not self:GetConsoleEnabled())
    end
end


ENT:AddHook("CanUseTardisControl", "console_on", function(self, control, ply, part)
    if self:GetData("console_on") and IsValid(part) and not control.bypass_console_toggle then
        return false
    end
end)
