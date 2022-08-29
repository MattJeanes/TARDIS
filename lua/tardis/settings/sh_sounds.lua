local SETTING_SECTION = "SoundsAndMusic"

if CLIENT then
    -- Developers should respect this setting before playing any sounds
    TARDIS:AddSetting({
        id = "sound",
        type = "bool",
        value = true,

        class="local",

        option = true,
        subsection = "Sounds",
        section = SETTING_SECTION,
        name = "All",
    })

    TARDIS:AddSetting({
        id="external_hum",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="ExternalHum",
    })

    TARDIS:AddSetting({
        id = "cloaksound-enabled",
        type = "bool",
        value = true,

        class="local",

        option = true,
        section = SETTING_SECTION,
        subsection="Sounds",
        name = "Cloak",
    })

    TARDIS:AddSetting({
        id="doorsounds-enabled",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Door",
    })

    TARDIS:AddSetting({
        id="flight-externalsound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="FlightExternal",
    })

    TARDIS:AddSetting({
        id="locksound-enabled",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Lock",
    })

    TARDIS:AddSetting({
        id="teleport-sound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Teleport",
    })

    TARDIS:AddSetting({
        id="cloistersound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="CloisterBells",
    })

    TARDIS:AddSetting({
        id="flight-internalsound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="FlightInternal",
    })

    TARDIS:AddSetting({
        id="idlesounds",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Idle",
    })
end

TARDIS:AddSetting({
    id="music-enabled",
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Music",
    name="Enabled",
})

TARDIS:AddSetting({
    id="music-volume",
    type="number",
    value=100,
    min=0,
    max=1000,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Music",
    name="Volume",
})

TARDIS:AddSetting({
    id="music-exit",
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Music",
    name="StopOnExit",
})