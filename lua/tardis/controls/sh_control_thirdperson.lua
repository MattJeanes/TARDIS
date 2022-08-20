TARDIS:AddControl({
    id = "thirdperson",
    ext_func=function(self,ply)
        self:PlayerThirdPerson(ply, not ply:GetTardisData("thirdperson"))
    end,
    serveronly=true,
    power_independent = true,
    bypass_isomorphic = true,
    screen_button = {
        virt_console = false,
        mmenu = true,
        toggle = false,
        frame_type = {0, 1},
        text = "Controls.ThirdPerson",
        order = 5,
    },
    tip_text = "Controls.ThirdPerson.Tip",
})