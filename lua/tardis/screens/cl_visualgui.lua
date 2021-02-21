TARDIS:AddSetting({
	id="visual_gui_enabled",
	name="Visual GUI Enabled",
	desc="Should new visual GUI be used?",
	section="Misc",
	value=false,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="visual_gui_bigpopup",
	name="Visual GUI big popup",
	desc="Should the popup for new visual GUI be bigger?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="visual_gui_screen_numrows",
	name="Visual GUI rows (screen)",
	desc="How many rows of buttons should the visual GUI on the screen have?",
	section="Misc",
	type="number",
	min=2,
	max=7,
	option=true,
	value=3
})

TARDIS:AddSetting({
	id="visual_gui_popup_numrows",
	name="Visual GUI rows (popup)",
	desc="How many rows of buttons should the visual GUI in the popup have?",
	section="Misc",
	type="number",
	min=2,
	max=7,
	option=true,
	value=4
})

TARDIS:AddSetting({
	id="visual_gui_controls",
	name="Visual GUI Controls",
	desc="Should new visual GUI have controls in it?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})
