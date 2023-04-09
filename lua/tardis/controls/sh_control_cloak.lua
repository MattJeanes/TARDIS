TARDIS:AddControl({
    id = "cloak",
    ext_func=function(self,ply)
        if self:ToggleCloak() then
            TARDIS:StatusMessage(ply, "Controls.Cloak.Status", self:GetCloak())
        else
            TARDIS:ErrorMessage(ply, "Controls.Cloak.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 1},
        text = "Controls.Cloak",
        pressed_state_data = "cloak",
        order = 12,
    },
    tip_text = "Controls.Cloak.Tip",
})