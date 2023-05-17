TARDIS:AddControl({
    id = "redecorate",
    ext_func=function(self,ply)
        if ply ~= self:GetCreator() then
            TARDIS:ErrorMessage(ply, "Controls.Redecorate.NotCreator")
            return
        end

        if self:ToggleRedecoration() then
            TARDIS:StatusMessage(ply, "Controls.Redecorate.Status", self:GetData("redecorate"))
        else
            TARDIS:ErrorMessage(ply, "Controls.Redecorate.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 1},
        text = "Controls.Redecorate",
        pressed_state_data = "redecorate",
        order = 4,
    },
    tip_text = "Controls.Redecorate.Tip",
})