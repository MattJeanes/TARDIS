TARDIS:AddControl({
    id = "toggle_scanners",
    int_func=function(self,ply)
        if self:ToggleScanners() then
            TARDIS:StatusMessage(ply, "Controls.ToggleScanners.Status", self:GetData("scanners_on"))
        else
            TARDIS:ErrorMessage(ply, "Controls.ToggleScanners.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        popup_only = true,
        toggle = true,
        frame_type = {2, 1},
        text = "Controls.ToggleScanners",
        pressed_state_from_interior = true,
        pressed_state_data = "scanners_on",
        order = 1,
    },
    tip_text = "Controls.ToggleScanners.Tip",
})