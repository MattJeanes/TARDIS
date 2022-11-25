local SETTING_SECTION = "Global"

CONVAR_FLAGS = {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}

TARDIS:AddSetting({
    id="health-enabled",
    type="bool",
    value=true,

    class="global",
    convar = {
        name = "tardis2_damage",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Damage enabled (1 enables, 0 disables)",
    },

    option = true,
    section=SETTING_SECTION,
    name="EnableHealth",
})

TARDIS:AddSetting({
    id="health-max",
    type="integer",
    value=1000,
    min=1,
    max=10000,
    round_func = function(x)
        if x < 50 then return x end
        if x < 500 then return (x - x % 10) end
        if x < 2000 then return (x - x % 100) end
        return (x - x % 500)
    end,

    class="global",
    convar = {
        name = "tardis2_maxhealth",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Maximum health",
    },

    option = true,
    section=SETTING_SECTION,
    name="MaxHealth",
})

TARDIS:AddSetting({
    id="long_repair",
    type="bool",
    value=true,

    class="global",
    convar = {
        name = "tardis2_long_repair",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Whether max repair time is 60 seconds instead of 15",
    },

    option = true,
    section=SETTING_SECTION,
    name="WaitLongForRepair",
})

TARDIS:AddSetting({
    id="artron_energy",
    type="bool",
    value=true,

    class="global",
    convar = {
        name = "tardis2_artron_energy",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Whether artron energy is enabled",
    },

    option = true,
    section=SETTING_SECTION,
    name="ArtronEnergyEnabled",
})

TARDIS:AddSetting({
    id="artron_energy_start",
    type="list",
    value=0.25,
    get_values_func = function()
        return {
            { "0%", 0.0 },
            { "25%", 0.25 },
            { "50%", 0.5 },
            { "75%", 0.75 },
            { "100%", 1.0 },
        }
    end,

    class="global",
    convar = {
        name = "tardis2_artron_energy_start",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Initial amount of artron energy",
    },

    option=true,
    section=SETTING_SECTION,
    name="ArtronEnergyStart",
})

TARDIS:AddSetting({
    id="artron_energy_max",
    type="integer",
    value=14400,
    min=1800,
    max=57600,
    round_func = function(x)
        if x > 20000 then return (x - x % 7200) end
        if x > 10000 then return (x - x % 3600) end
        return (x - x % 1800)
    end,

    class="global",
    convar = {
        name = "tardis2_artron_energy_max",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Max amount of artron energy",
    },

    option = true,
    section=SETTING_SECTION,
    name="ArtronEnergyMax",
})


TARDIS:AddSetting({
    id="boost-speed",
    type="number",
    value=2.5,
    min=1.0,
    max=8.0,
    round_func = function(x)
        return (x - x % 0.5)
    end,

    class="global",
    convar = {
        name = "tardis2_boost_speed",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Boost Speed",
    },

    option = true,
    section=SETTING_SECTION,
    name="BoostSpeed",
})
