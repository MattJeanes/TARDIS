TARDIS:AddSetting({
    id="visgui_enabled",
    name="VisGUI enabled",
    desc="Should new visual GUI be used?",
    section="GUI",
    value=true,
    type="bool",
    option=true,
    networked=false
})

TARDIS:AddSetting({
    id="visgui_bigpopup",
    name="VisGUI big popup",
    desc="Should the popup for new visual GUI be bigger?",
    section="GUI",
    value=true,
    type="bool",
    option=true,
    networked=false
})

TARDIS:AddSetting({
    id="visgui_screen_numrows",
    name="VisGUI rows (screen)",
    desc="How many rows of buttons should the visual GUI on the screen have?",
    section="GUI",
    type="integer",
    min=2,
    max=7,
    option=true,
    value=3
})

TARDIS:AddSetting({
    id="visgui_override_numrows",
    name="VisGUI override rows number",
    desc="Should the interior settings for button rows be overridable?",
    section="GUI",
    value=false,
    type="bool",
    option=true,
    networked=false
})

TARDIS:AddSetting({
    id="visgui_popup_numrows",
    name="VisGUI rows (popup)",
    desc="How many rows of buttons should the visual GUI in the popup have?",
    section="GUI",
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
    name = "VisGUI Theme",
    desc = "Theme for new Visual GUI",
    section = "GUI",
})