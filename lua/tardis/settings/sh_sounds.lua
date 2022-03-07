local SETTING_SECTION = "Sounds & Music"

if CLIENT then
    -- Developers should respect this setting before playing any sounds
    TARDIS:AddSetting({
        id = "sound",
        name = "All Sounds",
        desc = "Lets you easily mute all sounds",
        value = true,
        type = "bool",
        option = true,
        section = SETTING_SECTION,
        subsection="Sounds",
    })

    TARDIS:AddSetting({
        id="external_hum",
        name="External Hum",
        desc="Whether the hum on the outside of the TARDIS can be heard if it exists",
        section=SETTING_SECTION,
        subsection="Sounds",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({
        id = "cloaksound-enabled",
        name = "Cloak Sound",
        desc = "Whether or not sounds play when TARDIS cloaking is toggled",
        section = SETTING_SECTION,
        subsection="Sounds",
        value = true,
        type = "bool",
        option = true
    })

    TARDIS:AddSetting({
        id="doorsounds-enabled",
        name="Door Sound",
        desc="Whether a sound is made when toggling the door or not",
        section=SETTING_SECTION,
        subsection="Sounds",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({
        id="flight-externalsound",
        name="Flightmode External Sound",
        section=SETTING_SECTION,
        subsection="Sounds",
        desc="Whether the flight sound can be heard on the outside or not",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({
        id="locksound-enabled",
        name="Lock Sound",
        desc="Whether a sound is made when toggling the lock or not",
        section=SETTING_SECTION,
        subsection="Sounds",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({ id="teleport-sound",
        name="Teleport Sound",
        desc="Whether the teleport sounds can be heard or not",
        section=SETTING_SECTION,
        subsection="Sounds",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({
        id="cloistersound",
        name="Cloister bells",
        desc="Whether the warning bells can be heard on the interior or not",
        section=SETTING_SECTION,
        subsection="Sounds",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({
        id="flight-internalsound",
        name="Flightmode Internal Sound",
        section=SETTING_SECTION,
        subsection="Sounds",
        desc="Whether the flight sound can be heard on the inside or not",
        value=true,
        type="bool",
        option=true
    })

    TARDIS:AddSetting({
        id="idlesounds",
        name="Idle Sounds",
        desc="Whether the idle sounds can be heard on the inside or not",
        section=SETTING_SECTION,
        subsection="Sounds",
        value=true,
        type="bool",
        option=true
    })
end

TARDIS:AddSetting({
    id="music-enabled",
    name="Enabled",
    desc="Whether music is played through the screens or not",
    section=SETTING_SECTION,
    subsection="Music",
    value=true,
    type="bool",
    option=true
})

TARDIS:AddSetting({
    id="music-volume",
    name="Volume",
    desc="The volume of the music played through the screens",
    section=SETTING_SECTION,
    subsection="Music",
    value=100,
    type="number",
    min=0,
    max=100,
    option=true
})

TARDIS:AddSetting({
    id="music-exit",
    name="Stop on exit",
    desc="Whether music is stopped when leaving the TARDIS",
    section=SETTING_SECTION,
    subsection="Music",
    value=true,
    type="bool",
    option=true
})