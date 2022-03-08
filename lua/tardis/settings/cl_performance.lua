local SETTING_SECTION = "Performance"

TARDIS:AddSetting({
    id="lightoverride-enabled",
    type="bool",
    value=true,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="Lighting Override",
    desc="Better interior lighting independent from the map ambience.\nMay cause performance drops on lower end systems.",
})

TARDIS:AddSetting({
    id="portals-enabled",
    type="bool",
    value=true,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="Portals Enabled",
    desc="Whether portals will render or not, turn this off if they impact framerate significantly",
})

TARDIS:AddSetting({
    id="portals-closedist",
    type="number",
    value=1000,
    min=350,
    max=5000,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="Door Close Distance",
    desc="The distance at which the door automatically closes",
})

TARDIS:AddSetting({
    id="extlight-dynamic",
    type="bool",
    value=true,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="Dynamic Exterior Light",
    desc="Should the exterior emit dynamic lighting?",
})

TARDIS:AddSetting({
    id="extprojlight-enabled",
    type="bool",
    value=true,

    class="local",

    option=true,
    section=SETTING_SECTION,
    name="Projected Door Exterior Light",
    desc="Should light shine out through the doors when they're open?",
})