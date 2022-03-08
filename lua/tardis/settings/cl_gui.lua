local SETTING_SECTION = "GUI"

TARDIS:AddSetting({
    id="gui_old",
    type="bool",
    value=false,

    class="local",
    networked=false,

    option=true,
    section=SETTING_SECTION,
    name="Use old GUI",
    desc="Use the old 2D GUI with no pictures instead of the new one",
})

TARDIS:AddSetting({
    id="visgui_bigpopup",
    type="bool",
    value=true,

    class="local",
    networked=false,

    option=true,
    section=SETTING_SECTION,
    name="GUI big popup",
    desc="Should the popup for new visual GUI be bigger?",
})

TARDIS:AddSetting({
    id="visgui_screen_numrows",
    type="integer",
    value=3,
    min=2,
    max=7,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="GUI rows (screen)",
    desc="How many rows of buttons should the visual GUI on the screen have?",
})

TARDIS:AddSetting({
    id="visgui_override_numrows",
    type="bool",
    value=false,

    class="local",
    networked=false,

    option=true,
    section=SETTING_SECTION,
    name="GUI override screen rows",
    desc="Should the interior settings for button rows be overridable?",
})

TARDIS:AddSetting({
    id="visgui_popup_numrows",
    type="integer",
    value=4,
    min=2,
    max=7,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="GUI rows (popup)",
    desc="How many rows of buttons should the visual GUI in the popup have?",
})

TARDIS:AddSetting({
    id = "visgui_theme",
    type = "list",
    value = "default",

    get_values_func = function()
        local values = {}
        for k,v in pairs(TARDIS:GetGUIThemes()) do
            table.insert(values, {v.name, v.id})
        end
        return values
    end,

    class="local",

    option = true,
    section = SETTING_SECTION,
    name = "GUI Theme",
    desc = "Theme for the user interface",
})