TARDIS:AddControl({
    id = "engine_release",
    ext_func=function(self, ply)
        self:EngineReleaseDemat(nil, nil, function(result)
            if result then
                TARDIS:Message(ply, "Controls.EngineRelease.ForceDemat")
            elseif result == false then
                TARDIS:ErrorMessage(ply, "Controls.EngineRelease.FailedDemat")
            end
        end)
        if self:EngineReleaseVortexArtron() then
            TARDIS:Message(ply, "Controls.EngineRelease.ArtronAdded")
        end
        self:EngineReleaseFreePower()
    end,
    serveronly=true,
    power_independent = true,
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
