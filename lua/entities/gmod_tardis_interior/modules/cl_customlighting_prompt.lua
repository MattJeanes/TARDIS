--Require Lighting Override

TARDIS:AddSetting({
    id="light_override_request_noshow",
    name="don't show again",
    value=false,
    type="bool",
})

ENT:AddHook("PlayerInitialize", "customlightenable", function(self)
    local require_override = (self.metadata.Interior.RequireLightOverride == true) 
    local light_override = TARDIS:GetSetting("lightoverride-enabled", false)
    local noshow = TARDIS:GetSetting("light_override_request_noshow", false)
    if require_override and not light_override and not noshow then
        Derma_Query(
            "It is recommended to use Lighting Override with this TARDIS! This can be changed in the TARDIS settings later. Enable now?",
            "TARDIS Interior",
            "Yes",
            function()
                TARDIS:SetSetting("lightoverride-enabled", true)
            end,
            "No",
            nil,
            "Dont Show Again",function()
                TARDIS:SetSetting("light_override_request_noshow", true)
            end
        )
    end
end)