local SETTING_SECTION = "Admin Options"

CreateConVar("tardis2_maxhealth", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - Maximum health")
CreateConVar("tardis2_damage", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "TARDIS - Damage enabled (1 enables, 0 disables)", 0, 1)

TARDIS:AddSetting({
    id="health-enabled",
    type="bool",
    value=true,

    class="global",
    networked=true,

    option = false,
    section=SETTING_SECTION,
    name="Enable Health",
    desc="Should the TARDIS have health and take damage?",
})

TARDIS:AddSetting({
    id="health-max",
    type="integer",
    value=1000,
    min=1,
    max=50000,

    networked=true,
    class="global",

    option = false,
    section=SETTING_SECTION,
    name="Max Health",
    desc="Maximum ammount of health the TARDIS has",
})


TARDIS:AddSetting({
    id="boost-speed",
    type="number",
    value=2.5,
    min=1.0,
    max=4.0,

    class="global",
    networked=true,

    option = false,
    name="Boost Speed",
    desc="The increase of speed the TARDIS gets with the boost key enabled",
    section=SETTING_SECTION,
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
        TARDIS:SetSetting("boost-speed", nvnum)
    end, "UpdateOnChange")

    cvars.AddChangeCallback("tardis2_maxhealth", function(cvname, oldvalue, newvalue)
        local nvnum = tonumber(newvalue)
        if nvnum < 0 then
            nvnum = 1
        end
        TARDIS:SetSetting("health-max", nvnum)
        for k,v in pairs(ents.FindByClass("gmod_tardis")) do
            if v:GetHealth() > nvnum then
                v:ChangeHealth(nvnum)
            end
        end
    end, "UpdateOnChange")

    cvars.AddChangeCallback("tardis2_damage", function(cvname, oldvalue, newvalue)
       TARDIS:SetSetting("health-enabled", tobool(newvalue))
    end, "UpdateOnChange")
end
