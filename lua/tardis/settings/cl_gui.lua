local SETTING_SECTION = "GUI"

TARDIS:AddSetting({
    id="gui_old",
    type="bool",
    value=false,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="OldGUI",
})

TARDIS:AddSetting({
    id="visgui_bigpopup",
    type="bool",
    value=true,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="BigPopup",
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
    name="ScreenRows",
})

TARDIS:AddSetting({
    id="visgui_override_numrows",
    type="bool",
    value=false,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="ScreenOverrideRows",
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
    name="PopupRows",
})

TARDIS:AddSetting({
    id = "visgui_theme",
    type = "list",
    value = "default",

    get_values_func = function()
        local values = {}
        for k,v in pairs(TARDIS:GetGUIThemes()) do
            local name = "Themes."..v.name
            table.insert(values, {TARDIS:PhraseExists(name) and name or v.name, v.id})
        end
        return values
    end,

    class="local",

    option = true,
    section = SETTING_SECTION,
    name = "Theme",
})