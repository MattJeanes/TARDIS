TARDIS:AddControl({ id = "teleport_double",
    ext_func=function(self,ply,part)
        if (self:GetData("teleport") or self:GetData("vortex")) and part:GetOn() then
            self:Mat(function(result)
                if result then
                    TARDIS:Message(ply, "Controls.Teleport.Mat")
                else
                    TARDIS:ErrorMessage(ply, "Controls.Teleport.FailedMat")
                end
            end)
        elseif not part:GetOn() then
            local pos = pos or self:GetData("demat-pos") or self:GetPos()
            local ang = ang or self:GetData("demat-ang") or self:GetAngles()
            self:Demat(pos, ang, function(result)
                if result then
                    TARDIS:Message(ply, "Controls.Teleport.Demat")
                else
                    if self:GetData("doorstatereal", false) then
                        TARDIS:ErrorMessage(ply, "Controls.Teleport.FailedDematDoorsOpen")
                    elseif self:GetData("handbrake", false) then
                        TARDIS:ErrorMessage(ply, "Controls.Teleport.FailedDematHandbrake")
                    else
                        TARDIS:ErrorMessage(ply, "Controls.Teleport.FailedDemat")
                    end
                end
            end)
        end
    end,
    serveronly=true,
    power_independent = false,
    screen_button = false,
    tip_text = "Controls.Teleport.Tip",
})