TARDIS:AddControl({
    id = "door",
    ext_func = function(self,ply)
        local oldstate = self:GetData("doorstate")

        if self:GetData("locked", false) then
            TARDIS:ErrorMessage(ply, "Controls.Door.Locked")
            return
        end

        if not self:GetPower() then
            if not self.metadata.EnableClassicDoors or oldstate then
                TARDIS:ErrorMessage(ply, "Controls.Door.NoSwitch")
                TARDIS:ErrorMessage(ply, "Common.PowerDisabled")
                return
            end
            TARDIS:Message(ply, "Controls.Door.UsingEmergencyPower")
            TARDIS:ErrorMessage(ply, "Common.PowerDisabled")
        end

        if self:ToggleDoor() then
            TARDIS:StatusMessage(ply, "Controls.Door.Status", not oldstate, "Common.Opened.Lower", "Common.Closed.Lower")
        else
            TARDIS:ErrorMessage(ply, oldstate and "Controls.Door.FailedClose" or "Controls.Door.FailedOpen")
        end
    end,
    serveronly = true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 1},
        text = "Controls.Door",
        pressed_state_data = "doorstate",
        order = 10,
    },
    tip_text = "Controls.Door.Tip",
})