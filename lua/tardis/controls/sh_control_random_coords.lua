TARDIS:AddControl({
    id = "random_coords",
    ext_func=function(self,ply)
        self:SetRandomDestination(true)
        TARDIS:Message(ply, "Random destination has been selected")
    end,
    serveronly=true,
    power_independent = true,
    screen_button = false,
    tip_text = "Random Destination",
})