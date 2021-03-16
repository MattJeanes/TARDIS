TARDIS:AddSetting({
	id="visgui_enabled",
	name="VisGUI Enabled",
	desc="Should new visual GUI be used?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="visgui_bigpopup",
	name="VisGUI big popup",
	desc="Should the popup for new visual GUI be bigger?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="visgui_screen_numrows",
	name="VisGUI rows (screen)",
	desc="How many rows of buttons should the visual GUI on the screen have?",
	section="Misc",
	type="number",
	min=2,
	max=7,
	option=true,
	value=3
})

TARDIS:AddSetting({
	id="visgui_override_numrows",
	name="VisGUI override rows number",
	desc="Should the interior settings for button rows be overridable?",
	section="Misc",
	value=false,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="visgui_popup_numrows",
	name="VisGUI rows (popup)",
	desc="How many rows of buttons should the visual GUI in the popup have?",
	section="Misc",
	type="number",
	min=2,
	max=7,
	option=true,
	value=4
})
