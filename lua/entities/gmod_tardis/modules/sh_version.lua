-- Version

ENT:AddHook("Initialize", "version", function(self)
    if TARDIS:IsNewVersion() then
        self:CallHook("NewVersion")
    end

    TARDIS:SetLastUsedVersion()
end)

if CLIENT then
    ENT:AddHook("NewVersion", "version", function(self)
        -- TODO
        TARDIS:Message(self:GetCreator(), "New version of TARDIS detected! Please check the changelog for more information.")
    end)
end