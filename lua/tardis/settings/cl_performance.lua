local SETTING_SECTION = "Performance"

TARDIS:AddSetting({
    id="lightoverride-enabled",
    name="Lighting Override",
    desc="Better interior lighting independent from the map ambience.\nMay cause performance drops on lower end systems.",
    section=SETTING_SECTION,
    value=true,
    type="bool",
    option=true,
})

TARDIS:AddSetting({
	id="portals-enabled",
	name="Portals Enabled",
	section=SETTING_SECTION,
	desc="Whether portals will render or not, turn this off if they impact framerate significantly",
	value=true,
	type="bool",
	option=true
})

TARDIS:AddSetting({
	id="portals-closedist",
	name="Door Close Distance",
	section=SETTING_SECTION,
	desc="The distance at which the door automatically closes",
	value=1000,
	type="number",
	min=350,
	max=5000,
	option=true
})

TARDIS:AddSetting({
	id="extlight-dynamic",
	type="bool",
	value=true,

	option=true,
	name="Dynamic Exterior Light",
	section=SETTING_SECTION,
	desc="Should the exterior emit dynamic lighting?",
})

TARDIS:AddSetting({
    id="extprojlight-enabled",
    type="bool",
    value=true,

    option=true,
    name="Projected Door Exterior Light",
    section=SETTING_SECTION,
    desc="Should light shine out through the doors when they're open?",
})