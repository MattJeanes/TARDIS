TARDIS:AddControl({
    id = "stabilizers",
    ext_func=function(self,ply)
        TARDIS:Message(ply, "Common.NotYetImplemented")
    end,
    clientonly=true,
    power_independent = false,
    screen_button = {
        virt_console = false,
        mmenu = false,
    },
    tip_text = "Controls.Stabilizers.Tip",
})