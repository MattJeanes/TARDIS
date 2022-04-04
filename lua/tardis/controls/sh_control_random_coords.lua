TARDIS:AddControl({
    id = "random_coords",
    ext_func=function(self,ply)
        self:SetRandomDestination(true)
    end,
    serveronly=true,
    power_independent = true,
    screen_button = false,
    tip_text = "Randomised Coordinates",
})