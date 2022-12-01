TARDIS:AddControl({
    id = "engine_release",
    ext_func=function(self, ply)
        local pos = pos or self:GetData("demat-pos") or self:GetPos()
        local ang = ang or self:GetData("demat-ang") or self:GetAngles()
        self:EngineReleaseDemat(pos, ang, function(result)
            if result then
                TARDIS:Message(ply, "Controls.EngineRelease.ForceDemat")
            elseif result == false then
                TARDIS:ErrorMessage(ply, "Controls.EngineRelease.FailedDemat")
            end
        end)
        self:EngineReleaseVortexArtron(function(result)
            if result then
                TARDIS:Message(ply, "Controls.EngineRelease.ArtronAdded")
            end
        end)
    end,
    serveronly=true,
    power_independent = false,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = false,
        frame_type = {0, 1},
        text = "Controls.EngineRelease",
        order = 8,
    },
    tip_text = "Controls.EngineRelease.Tip",
})
