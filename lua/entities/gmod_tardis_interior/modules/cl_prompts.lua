--Prompts

ENT:AddHook("PlayerEnter", "lightingoverride_prompt", function(self)
    local require_override = (self.metadata.Interior.RequireLightOverride == true) 
    local light_override = TARDIS:GetSetting("lightoverride-enabled")
    local noshow = TARDIS:GetSetting("light_override_prompt_noshow")
    if require_override and not light_override and not noshow then
        Derma_Query(
            TARDIS:GetPhrase("Prompts.LightingOverride"),
            TARDIS:GetPhrase("Common.TARDIS"),
            TARDIS:GetPhrase("Common.Yes"),
            function()
                TARDIS:SetSetting("lightoverride-enabled", true)
            end,
            TARDIS:GetPhrase("Common.No"),
            nil,
            TARDIS:GetPhrase("Common.DontAskAgain"),
            function()
                TARDIS:SetSetting("light_override_prompt_noshow", true)
            end
        )
    end
end)

ENT:AddHook("PlayerEnter", "lod_prompt", function(self)
    if self.metadata.Interior.RequireHighModelDetail ~= false and GetConVarNumber("r_rootlod")>0 then
            Derma_Query(
            TARDIS:GetPhrase("Prompts.LOD"),
            TARDIS:GetPhrase("Common.TARDIS"),
            TARDIS:GetPhrase("Common.Yes"),
            function()
                RunConsoleCommand("r_rootlod", 0)
            end,
            TARDIS:GetPhrase("Common.No"),
            nil
        )
    end
end)