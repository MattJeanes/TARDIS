TARDIS:AddControl({
    id = "vortex_flight",
    ext_func = function(self,ply)
        if self:ToggleFastRemat() then
            TARDIS:StatusMessage(ply, "Controls.VortexFlight.Status", self:GetFastRemat(), "Common.Disabled.Lower", "Common.Enabled.Lower")
        else
            TARDIS:ErrorMessage(ply, "Controls.VortexFlight.FailedToggle")
        end
    end,
    serveronly = true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {1, 2},
        text = "Controls.VortexFlight",
        pressed_state_data = "demat-fast",
        order = 8,
    },
    tip_text = "Controls.VortexFlight.Tip",
})