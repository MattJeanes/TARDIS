TARDIS:AddControl({
    id = "random_coords",
    ext_func=function(self,ply)
        self:SetRandomDestination(not self:GetData("float"))
        
        TARDIS:Message(ply, "Controls.RandomCoords.Selected")
    end,
    serveronly = true,
    power_independent = false,
    screen_button = false,
    tip_text = "Controls.RandomCoords.Tip",
})