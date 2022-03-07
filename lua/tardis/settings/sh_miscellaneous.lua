local SETTING_SECTION = "Misc"

TARDIS:AddSetting({
    id="notification_type",
    type="list",
    value=3,
    networked=true,

    get_values_func = function()
        return {
            { "Disabled", 0 },
            { "Console log", 1 },
            { "Chat notifications", 2 },
            { "In-built notifications", 3 },
        }
    end,

    option=true,
    section=SETTING_SECTION,
    name="Notification type",
    desc="Which type of notifications is being used"
})

TARDIS:AddSetting({
    id="csequences-enabled",
    name="Enable Control Sequences",
    desc="Should control sequences or 'advanced mode' be used?",
    section=SETTING_SECTION,
    value=false,
    type="bool",
    option=true,
    networked=true
})

TARDIS:AddSetting({
    id="security",
    type="bool",
    value=false,

    option=true,
    section=SETTING_SECTION,
    name="Isomorphic Security on by default",
    networked=true,
    desc="Whether or not others can use your TARDIS' controls by default."
})

--------------------------------------------------------------------------------
-- Teleport

TARDIS:AddSetting({
    id="teleport-door-autoclose",
    name="Auto-Close Doors at Demat",
    desc="Should TARDIS close doors automatically before demat?",
    section=SETTING_SECTION,
    subsection="Teleport",
    value=false,
    type="bool",
    option=true,
    networked=true
})

TARDIS:AddSetting({
    id="breakdown-effects",
    name="Breakdown Effects",
    desc="Should TARDIS have sparkling and explosion effects in emergency moments?",
    section=SETTING_SECTION,
    subsection="Teleport",
    value=true,
    type="bool",
    option=true,
    networked=true
})

TARDIS:AddSetting({
    id="dest-onsetdemat",
    name="Destination - Demat on Set",
    desc="Should the TARDIS dematerialise immediately after destination is set?",
    section=SETTING_SECTION,
    subsection="Teleport",
    value=false,
    type="bool",
    option=true,
    networked=true
})

TARDIS:AddSetting({
    id="vortex-enabled",
    name="Show Vortex",
    desc="Whether the vortex is shown during vortex flight",
    section=SETTING_SECTION,
    subsection="Teleport",
    value=true,
    type="bool",
    option=true,
    networked=true
})

--------------------------------------------------------------------------------
-- Flight

TARDIS:AddSetting({
    id="opened-door-no-spin",
    name="Stop spinning with opened door",
    desc="Should the TARDIS stop spinning when doors are opened in flight?",
    section=SETTING_SECTION,
    subsection="Flight",
    value=true,
    type="bool",
    option=true,
    networked=true
})

TARDIS:AddSetting({
    id="opened-door-no-boost",
    name="Disable boost with opened doors",
    desc="Should the TARDIS boost stop working when doors are opened in flight?",
    section=SETTING_SECTION,
    subsection="Flight",
    value=false,
    type="bool",
    option=true,
    networked=true
})

TARDIS:AddSetting({
    id="thirdperson_careful_enabled",
    name="Use walk key to enter third person",
    desc="Should the WALK ('ALT' by default) key be pressed to enter third person when pressing USE ('E' by default) key on the console?",
    section=SETTING_SECTION,
    subsection="Flight",
    value=true,
    type="bool",
    option=true,
    networked=true
})

--------------------------------------------------------------------------------
-- Tips

TARDIS:AddSetting({
    id="tips",
    value=true,
    type="bool",
    networked=false,

    option=true,
    name="Tips",
    section=SETTING_SECTION,
    subsection="Tips",
    desc="Should tips be shown for TARDIS controls?",
})

TARDIS:AddSetting({
    id="tips_style",
    type="list",
    value="default",
    networked=false,

    get_values_func = function()
        local values = {}
        for k,v in pairs(TARDIS:GetTipStyles()) do
            table.insert(values, {v.style_name, v.style_id})
        end
        return values
    end,

    option=true,
    section=SETTING_SECTION,
    subsection="Tips",
    name="Tips Style",
    desc="Which style should the TARDIS tips use?",
})

--------------------------------------------------------------------------------
-- Spawning the TARDIS

TARDIS:AddSetting({
    id="use_classic_door_interiors",
    name="Prefer classic door interiors",
    value=true,
    type="bool",
    networked=true,
    option=true,
    section=SETTING_SECTION,
    subsection="Spawning the TARDIS",
    desc="Whether classic (big) door versions of interiors will spawn by default"
})

TARDIS:AddSetting({
    id="randomize_skins",
    type="bool",
    value=true,
    networked=true,

    option=true,
    section=SETTING_SECTION,
    subsection="Spawning the TARDIS",
    name="Randomize skins",
    desc="Whether or not TARDIS skin will be randomized when it's spawned"
})

TARDIS:AddSetting({
    id="winter_skins",
    type="bool",
    value=false,
    networked=true,

    option=true,
    section=SETTING_SECTION,
    subsection="Spawning the TARDIS",
    name="Use winter skins",
    desc="Whether or not winter TARDIS skins will be used while it's randomized"
})

--------------------------------------------------------------------------------
-- Developer Tools

TARDIS:AddSetting({
    id="debug",
    type="bool",
    value=false,
    networked=true,

    option=true,
    section=SETTING_SECTION,
	subsection="Developer tools",
    name="Enable debug info",
    desc="Whether or not TARDIS debug messages will be printed"
})

TARDIS:AddSetting({
    id="debug_chat",
    type="bool",
    value=false,
    networked=true,

    option=true,
    section=SETTING_SECTION,
	subsection="Developer tools",
    name="Print debug info in chat",
    desc="Whether or not TARDIS debug messages will be duplicated in chat"
})

--------------------------------------------------------------------------------
-- Tips

