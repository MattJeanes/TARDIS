TARDIS:AddControl({
    id = "exterior_light",
    ext_func=function(self,ply)
        TARDIS:StatusMessage(ply, "Controls.ExteriorLight.Status", self:ToggleFlashLight())
    end,
    serveronly=true,
    power_independent = false,
    screen_button = {
        virt_console = false,
        mmenu = false,
    },
    tip_text = "Controls.ExteriorLight.Tip",
})