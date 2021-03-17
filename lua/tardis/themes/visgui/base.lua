local theme = {
	id = "base",
	name = "Base",
	base_id = nil,

	folder = "base",
	frames = {
		subfolder = nil,
		default = "frame.png",
		on = "frame_on.png",
		off = "frame_off.png",
	},
	backgrounds = {
		subfolder = nil,
		default = "background.png",
		-- virtualconsole
		-- main
	},
	text_icons_off = {
		subfolder = nil,
		default = "empty.png",
	},
	text_icons_on = {
		subfolder = nil,
		default = "empty.png",
	},
}

TARDIS:AddGUITheme(theme)