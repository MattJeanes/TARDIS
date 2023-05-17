TARDIS:AddControl({
    id = "physlock",
    ext_func=function(self,ply)
        if self:TogglePhyslock() then
            TARDIS:StatusMessage(ply, "Controls.Physlock.Status", self:GetPhyslock(), "Common.Engaged.Lower", "Common.Disengaged.Lower")
        else
            TARDIS:ErrorMessage(ply, "Controls.Physlock.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 2},
        text = "Controls.Physlock",
        pressed_state_data = "physlock",
        order = 12,
    },
    tip_text = "Controls.Physlock.Tip",
})