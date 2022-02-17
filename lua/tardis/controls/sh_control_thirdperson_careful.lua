TARDIS:AddControl({
    id = "thirdperson_careful",
    ext_func=function(self,ply)
        self:PlayerThirdPerson(ply, not ply:GetTardisData("thirdperson"), true)
    end,
    serveronly=true,
    power_independent = true,
    screen_button = false,
    tip_text = "Manual Flight Control",
})