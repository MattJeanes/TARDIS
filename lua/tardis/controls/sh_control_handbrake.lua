TARDIS:AddControl({
    id = "handbrake",
    ext_func=function(self, ply)
        if self:ToggleHandbrake() then
            TARDIS:StatusMessage(ply, "Controls.Handbrake.Status", self:GetData("handbrake"), "Common.Engaged.Lower", "Common.Disengaged.Lower")
        else
            TARDIS:ErrorMessage(ply, "Controls.Handbrake.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 2},
        text = "Controls.Handbrake",
        pressed_state_from_interior = false,
        pressed_state_data = "handbrake", -- can be changed
        order = 7,
    },
    tip_text = "Controls.Handbrake.Tip",
})