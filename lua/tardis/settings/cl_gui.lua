local SETTING_SECTION = "GUI"

TARDIS:AddSetting({
    id="gui_old",
    name="Use old GUI",
    desc="Use the old 2D GUI with no pictures instead of the new one",
    section=SETTING_SECTION,
    value=false,
    type="bool",
    option=true,
    networked=false
})

TARDIS:AddSetting({
    id="visgui_bigpopup",
    name="GUI big popup",
    desc="Should the popup for new visual GUI be bigger?",
    section=SETTING_SECTION,
    value=true,
    type="bool",
    option=true,
    networked=false
})

TARDIS:AddSetting({
    id="visgui_screen_numrows",
    name="GUI rows (screen)",
    desc="How many rows of buttons should the visual GUI on the screen have?",
    section=SETTING_SECTION,
    type="integer",
    min=2,
    max=7,
    option=true,
    value=3
})

TARDIS:AddSetting({
    id="visgui_override_numrows",
    name="GUI override screen rows",
    desc="Should the interior settings for button rows be overridable?",
    section=SETTING_SECTION,
    value=false,
    type="bool",
    option=true,
    networked=false
})

TARDIS:AddSetting({
    id="visgui_popup_numrows",
    name="GUI rows (popup)",
    desc="How many rows of buttons should the visual GUI in the popup have?",
    section=SETTING_SECTION,
    type="integer",
    min=2,
    max=7,
    option=true,
    value=4
})

TARDIS:AddSetting({
    id = "visgui_theme",
    type = "list",
    value = "default",
    networked = true,

    get_values_func = function()
        local values = {}
        for k,v in pairs(TARDIS:GetGUIThemes()) do
            table.insert(values, {v.name, v.id})
        end
        return values
    end,

    option = true,
    name = "GUI Theme",
    desc = "Theme for the user interface",
    section = SETTING_SECTION,
})