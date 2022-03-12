local SETTING_SECTION = "Sounds & Music"

if CLIENT then
    -- Developers should respect this setting before playing any sounds
    TARDIS:AddSetting({
        id = "sound",
        type = "bool",
        value = true,

        class="local",

        option = true,
        subsection="Sounds",
        section = SETTING_SECTION,
        name = "All Sounds",
        desc = "Lets you easily mute all sounds",
    })

    TARDIS:AddSetting({
        id="external_hum",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="External Hum",
        desc="Whether the hum on the outside of the TARDIS can be heard if it exists",
    })

    TARDIS:AddSetting({
        id = "cloaksound-enabled",
        type = "bool",
        value = true,

        class="local",

        option = true,
        section = SETTING_SECTION,
        subsection="Sounds",
        name = "Cloak Sound",
        desc = "Whether or not sounds play when TARDIS cloaking is toggled",
    })

    TARDIS:AddSetting({
        id="doorsounds-enabled",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Door Sound",
        desc="Whether a sound is made when toggling the door or not",
    })

    TARDIS:AddSetting({
        id="flight-externalsound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Flightmode External Sound",
        desc="Whether the flight sound can be heard on the outside or not",
    })

    TARDIS:AddSetting({
        id="locksound-enabled",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Lock Sound",
        desc="Whether a sound is made when toggling the lock or not",
    })

    TARDIS:AddSetting({
        id="teleport-sound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Teleport Sound",
        desc="Whether the teleport sounds can be heard or not",
    })

    TARDIS:AddSetting({
        id="cloistersound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Cloister bells",
        desc="Whether the warning bells can be heard on the interior or not",
    })

    TARDIS:AddSetting({
        id="flight-internalsound",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        desc="Whether the flight sound can be heard on the inside or not",
        name="Flightmode Internal Sound",
    })

    TARDIS:AddSetting({
        id="idlesounds",
        type="bool",
        value=true,

        class="local",

        option=true,
        section=SETTING_SECTION,
        subsection="Sounds",
        name="Idle Sounds",
        desc="Whether the idle sounds can be heard on the inside or not",
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
    desc="Whether music is played through the screens or not",
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
    desc="The volume of the music played through the screens",
})

TARDIS:AddSetting({
    id="music-exit",
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Music",
    name="Stop on exit",
    desc="Whether music is stopped when leaving the TARDIS",
})