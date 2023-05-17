TARDIS:AddControl({
    id = "toggle_console",
    int_func=function(self,ply)
        TARDIS:StatusMessage(ply, "Controls.ToggleConsole.Status", self:ToggleConsole())
    end,
    serveronly=true,
    power_independent = true,
    bypass_console_toggle = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        popup_only = false,
        toggle = true,
        frame_type = {2, 1},
        text = "Controls.ToggleConsole",
        pressed_state_from_interior = true,
        pressed_state_data = "console_on",
        order = 17,
    },
    tip_text = "Controls.ToggleConsole.Tip",
})