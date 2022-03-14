local SETTING_SECTION = "Misc"

TARDIS:AddSetting({
    id="notification_type",
    type="list",
    value=3,
    get_values_func = function()
        return {
            { "Disabled", 0 },
            { "Console log", 1 },
            { "Chat notifications", 2 },
            { "In-built notifications", 3 },
        }
    end,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    name="Notification type",
    desc="Which type of notifications is being used"
})

TARDIS:AddSetting({
    id="csequences-enabled",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    name="Enable Control Sequences",
    desc="Should control sequences or 'advanced mode' be used?",
})

TARDIS:AddSetting({
    id="security",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    name="Isomorphic Security on by default",
    desc="Whether or not others can use your TARDIS' controls by default."
})

--------------------------------------------------------------------------------
-- Teleport

TARDIS:AddSetting({
    id="teleport-door-autoclose",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Teleport",
    name="Auto-Close Doors at Demat",
    desc="Should TARDIS close doors automatically before demat?",
})

TARDIS:AddSetting({
    id="dest-onsetdemat",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Teleport",
    name="Destination - Demat on Set",
    desc="Should the TARDIS dematerialise immediately after destination is set?",
})

TARDIS:AddSetting({
    id="vortex-enabled",
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Teleport",
    name="Show Vortex",
    desc="Whether the vortex is shown during vortex flight",
})

--------------------------------------------------------------------------------
-- Flight

TARDIS:AddSetting({
    id="opened-door-no-spin",
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Flight",
    name="Stop spinning with opened door",
    desc="Should the TARDIS stop spinning when doors are opened in flight?",
})

TARDIS:AddSetting({
    id="opened-door-no-boost",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Flight",
    name="Disable boost with opened doors",
    desc="Should the TARDIS boost stop working when doors are opened in flight?",
})

TARDIS:AddSetting({
    id="thirdperson_careful_enabled",
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Flight",
    name="Use walk key to enter third person",
    desc="Should the WALK ('ALT' by default) key be pressed to enter third person when pressing USE ('E' by default) key on the console?",
})

--------------------------------------------------------------------------------
-- Tips

TARDIS:AddSetting({
    id="tips",
    type="bool",
    value=true,

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Tips",
    name="Tips",
    desc="Should tips be shown for TARDIS controls?",
})

TARDIS:AddSetting({
    id="tips_style",
    type="list",
    value="default",

    get_values_func = function()
        local values = {}
        for k,v in pairs(TARDIS:GetTipStyles()) do
            table.insert(values, {v.style_name, v.style_id})
        end
        return values
    end,

    class="local",

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
    type="bool",
    value=true,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Spawning the TARDIS",
    name="Prefer classic door interiors",
    desc="Whether classic (big) door versions of interiors will spawn by default"
})

TARDIS:AddSetting({
    id="randomize_skins",
    type="bool",
    value=true,

    class="networked",

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

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Spawning the TARDIS",
    name="Use winter skins",
    desc="Whether or not winter TARDIS skins will be used while it's randomized"
})

--------------------------------------------------------------------------------

TARDIS:AddSetting({
    id="intdoor_behaviour",
    type="list",
    value="non-clickable",
    get_values_func = function()
        return {
            { "Default (set by interior)", "default" },
            { "Sync with exterior doors", "sync" },
            { "Openable by hand", "clickable" },
            { "Non-clickable (use the switch)", "non-clickable" },
        }
    end,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Spawning the TARDIS",
    name="Double Door Behaviour",
    desc="How the double door will be opened/closed"
})

