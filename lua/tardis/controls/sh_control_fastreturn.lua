TARDIS:AddControl({
    id = "fastreturn",
    ext_func=function(self,ply)
        self:FastReturn(function(result)
            if result then
                TARDIS:Message(ply, "Controls.FastReturn.Activated")
            else
                TARDIS:ErrorMessage(ply, "Controls.FastReturn.Failed")
            end
        end)
    end,
    serveronly = true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = false,
        frame_type = {0, 1},
        text = "Controls.FastReturn",
        order = 9,
    },
    tip_text = "Controls.FastReturn.Tip",
})