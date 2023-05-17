TARDIS:AddControl({
    id = "doorlock",
    ext_func=function(self,ply)
        if not self:GetPower() and not self:GetData("locked", false) then
            TARDIS:ErrorMessage(ply, "Controls.DoorLock.NotWorking")
            TARDIS:ErrorMessage(ply, "Common.PowerDisabled")
            return
        elseif not self:GetPower() then
            TARDIS:Message(ply, "Controls.DoorLock.UsingEmergencyPower")
            TARDIS:ErrorMessage(ply, "Common.PowerDisabled")
        end

        self:ToggleLocked(function(result)
            if result then
                TARDIS:StatusMessage(ply, "Controls.Door.Status", self:GetData("locked"), "Common.Locked.Lower", "Common.Unlocked.Lower")
            else
                TARDIS:ErrorMessage(ply, "Controls.DoorLock.FailedToggle")
            end
        end)
    end,
    serveronly=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {1, 2},
        text = "Controls.DoorLock",
        pressed_state_data = "locked",
        order = 10,
    },
    tip_text = "Controls.DoorLock.Tip",
})