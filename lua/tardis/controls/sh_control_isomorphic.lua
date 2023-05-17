TARDIS:AddControl({
    id = "isomorphic",
    int_func=function(self,ply)
        if ply ~= self:GetCreator() then
            TARDIS:ErrorMessage(ply, "Controls.Isomorphic.NotCreator")
            return
        end
        if game.SinglePlayer() then
            TARDIS:ErrorMessage(ply, "Controls.Isomorphic.SingleplayerWarning")
        end
        if self:ToggleSecurity() then
            TARDIS:StatusMessage(ply, "Controls.Isomorphic.Status", self:GetData("security"))
        else
            TARDIS:ErrorMessage(ply, "Controls.Isomorphic.FailedToggle")
        end
    end,
    serveronly = true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {2, 1},
        text = "Controls.Isomorphic",
        pressed_state_data = "security",
        order = 15,
    },
    tip_text = "Controls.Isomorphic.Tip",
})