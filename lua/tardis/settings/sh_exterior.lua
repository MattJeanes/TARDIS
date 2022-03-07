local SETTING_SECTION = "Exterior"

--------------------------------------------------------------------------------
-- Exterior light

TARDIS:AddSetting({
	id="extlight-override-color",
	type="bool",
	value=false,
	networked=true,

	option=true,
	name="Enable Light Color Override",
	section=SETTING_SECTION,
	subsection="Exterior light",
	desc="Whether the override of exterior light color is enabled",
})

TARDIS:AddSetting({
	id="extlight-color",
	type="color",
	value=Color(255,255,255),
	networked=true,

	option=true,
	name="Color Override",
	section=SETTING_SECTION,
	subsection="Exterior light",
	desc="The override color of the exterior light",
})

TARDIS:AddSetting({
	id="extlight-alwayson",
	type="bool",
	value=false,

	option=true,
	name="Exterior Light Always On",
	section=SETTING_SECTION,
	subsection="Exterior light",
	desc="Should the exterior light always be lit?",
})

--------------------------------------------------------------------------------
-- Projected light

TARDIS:AddSetting({
    id="extprojlight-override-brightness",
    type="bool",
    value=false,

    option=true,
    name="Enable Brightness Override",
    section=SETTING_SECTION,
    subsection="Projected light",
    desc="Whether the override of light brightness is enabled",
})

TARDIS:AddSetting({
    id="extprojlight-override-color",
    type="bool",
    value=false,

    option=true,
    name="Enable Color Override",
    section=SETTING_SECTION,
    subsection="Projected light",
    desc="Whether the override of projected light color is enabled",
})

TARDIS:AddSetting({
    id="extprojlight-override-distance",
    type="bool",
    value=false,

    option=true,
    name="Enable Distance Override",
    section=SETTING_SECTION,
    subsection="Projected light",
    desc="Whether the override of light distance is enabled",
})

TARDIS:AddSetting({
    id="extprojlight-brightness",
    type="number",
    value=0.1,
    min=0,
    max=10,

    option=true,
    name="Brightness Override",
    section=SETTING_SECTION,
    subsection="Projected light",
    desc="Override brightness of projected light",
})

TARDIS:AddSetting({
    id="extprojlight-distance",
    type="number",
    value=750,
    min=0,
    max=5000,

    option=true,
    name="Distance Override",
    section=SETTING_SECTION,
    subsection="Projected light",
    desc="Override distance of projected light",
})

TARDIS:AddSetting({
    id="extprojlight-color",
    type="color",
    value=Color(255,255,255),

    option=true,
    name="Color Override",
    section=SETTING_SECTION,
    subsection="Projected light",
    desc="Override color of projected light",
})