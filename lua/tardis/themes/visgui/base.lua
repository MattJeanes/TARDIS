local theme = {
	id = "base",
	name = "Base",
	base = nil,

	folder = "base",
	frames = {
		default = "frame.png",
		on = "frame_on.png",
		off = "frame_off.png",
	},
	backgrounds = {
		default = "background.png",
		-- virtualconsole
		-- main
	},
	text_icons_on = {
		default = "empty.png",
	},
	text_icons_off = {
		default = "empty.png",
	},
}
TARDIS:AddGUITheme(theme)