--Prompts

ENT:AddHook("PlayerEnter", "lightingoverride_prompt", function(self)
    local require_override = (self:GetMetadata().Interior.RequireLightOverride == true) 
    local light_override = TARDIS:GetSetting("lightoverride-enabled")
    local noshow = TARDIS:GetSetting("light_override_prompt_noshow")
    if require_override and not light_override and not noshow then
        Derma_Query(
            "This TARDIS recommends Lighting Override which you do not have enabled. Enable now? This can be changed in TARDIS settings later.",
            "TARDIS Interior",
            "Yes",
            function()
                TARDIS:SetSetting("lightoverride-enabled", true)
            end,
            "No",
            nil,
            "Don't Show Again",function()
                TARDIS:SetSetting("light_override_prompt_noshow", true)
            end
        )
    end
end)

ENT:AddHook("PlayerEnter", "lod_prompt", function(self)
    if self:GetMetadata().Interior.RequireHighModelDetail ~= false and GetConVarNumber("r_rootlod")>0 then
            Derma_Query(
            "The TARDIS Interior may require model detail on high, set now?",
            "TARDIS Interior",
            "Yes",
            function()
                RunConsoleCommand("r_rootlod", 0)
            end,
            "No",
            nil
        )
    end
end)