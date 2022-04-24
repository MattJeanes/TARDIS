local SETTING_SECTION = "Exterior"

--------------------------------------------------------------------------------
-- Exterior light

TARDIS:AddSetting({
    id="extlight-override-color",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Exterior light",
    name="Enable Light Color Override",
    desc="Whether the override of exterior light color is enabled",
})

TARDIS:AddSetting({
    id="extlight-color",
    type="color",
    value=Color(255,255,255),

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Exterior light",
    name="Color Override",
    desc="The override color of the exterior light",
})

TARDIS:AddSetting({
    id="extlight-alwayson",
    type="bool",
    value=false,

    class="networked",

    option=true,
    section=SETTING_SECTION,
    subsection="Exterior light",
    name="Exterior Light Always On",
    desc="Should the exterior light always be lit?",
})

--------------------------------------------------------------------------------
-- Projected light

TARDIS:AddSetting({
    id="extprojlight-override-brightness",
    type="bool",
    value=false,

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Projected light",
    name="Enable Brightness Override",
    desc="Whether the override of light brightness is enabled",
})

TARDIS:AddSetting({
    id="extprojlight-override-color",
    type="bool",
    value=false,

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Projected light",
    name="Enable Color Override",
    desc="Whether the override of projected light color is enabled",
})

TARDIS:AddSetting({
    id="extprojlight-override-distance",
    type="bool",
    value=false,

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Projected light",
    name="Enable Distance Override",
    desc="Whether the override of light distance is enabled",
})

TARDIS:AddSetting({
    id="extprojlight-brightness",
    type="number",
    value=0.1,
    min=0,
    max=10,

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Projected light",
    name="Brightness Override",
    desc="Override brightness of projected light",
})

TARDIS:AddSetting({
    id="extprojlight-distance",
    type="number",
    value=750,
    min=0,
    max=5000,

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Projected light",
    name="Distance Override",
    desc="Override distance of projected light",
})

TARDIS:AddSetting({
    id="extprojlight-color",
    type="color",
    value=Color(255,255,255),

    class="local",

    option=true,
    section=SETTING_SECTION,
    subsection="Projected light",
    name="Color Override",
    desc="Override color of projected light",
})