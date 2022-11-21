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
    id="artron_energy_full",
    type="bool",
    value=false,

    class="global",
    convar = {
        name = "tardis2_artron_energy_full",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Start with full artron energy charge",
    },

    option = true,
    section=SETTING_SECTION,
    name="ArtronEnergyFull",
})

TARDIS:AddSetting({
    id="artron_energy_max",
    type="integer",
    value=1000,
    min=500,
    max=50000,

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
