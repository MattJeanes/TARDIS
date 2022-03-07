local SETTING_SECTION = "Admin Options"

CreateConVar("tardis2_maxhealth", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - Maximum health")
CreateConVar("tardis2_damage", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "TARDIS - Damage enabled (1 enables, 0 disables)", 0, 1)

TARDIS:AddSetting({
    id="health-enabled",
    name="Enable Health",
    desc="Should the TARDIS have health and take damage?",
    section=SETTING_SECTION,
    value=true,
    type="bool",
    setting=true,
    networked=true
})

TARDIS:AddSetting({
    id="health-max",
    name="Max Health",
    desc="Maximum ammount of health the TARDIS has",
    section=SETTING_SECTION,
    type="integer",
    value=1000,
    min=1,
    max=50000,
    networked=true
})


TARDIS:AddSetting({
    id="boost-speed",
    name="Boost Speed",
    desc="The increase of speed the TARDIS gets with the boost key enabled",
    section=SETTING_SECTION,
    type="number",
    value=2.5,
    min=1.0,
    max=4.0,
    networked=true
})

CreateConVar("tardis2_boost_speed", 2.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - Boost Speed")

if SERVER then
    cvars.AddChangeCallback("tardis2_boost_speed", function(cvname, oldvalue, newvalue)
        local nvnum = tonumber(newvalue)
        if nvnum < 1.0 or nvnum > 4.0 then
            nvnum = math.max(1.0, math.min(4.0, nvnum))
            GetConVar("tardis2_boost_speed"):SetFloat(nvnum)
            return
        end
        print("TARDIS boost speed has been set to "..nvnum)
        TARDIS:SetSetting("boost-speed", nvnum, true)
    end, "UpdateOnChange")

	cvars.AddChangeCallback("tardis2_maxhealth", function(cvname, oldvalue, newvalue)
        local nvnum = tonumber(newvalue)
        if nvnum < 0 then
            nvnum = 1
        end
        TARDIS:SetSetting("health-max", nvnum, true)
        for k,v in pairs(ents.FindByClass("gmod_tardis")) do
            if v:GetHealth() > nvnum then
                v:ChangeHealth(nvnum)
            end
        end
    end, "UpdateOnChange")

    cvars.AddChangeCallback("tardis2_damage", function(cvname, oldvalue, newvalue)
       TARDIS:SetSetting("health-enabled", tobool(newvalue), true)
    end, "UpdateOnChange")
end

--[[
CreateConVar("tardis2_debug", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - debug enabled")
cvars.AddChangeCallback("tardis2_debug", function()
    TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
end)

CreateConVar("tardis2_debug_chat", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - print debug to chat as well")
cvars.AddChangeCallback("tardis2_debug_chat", function()
    TARDIS.debug_chat = GetConVar("tardis2_debug_chat"):GetBool()
end)

TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
TARDIS.debug_chat = GetConVar("tardis2_debug_chat"):GetBool()
]]