local style = {
	style_id = "white_on_grey",
	style_name = "white on grey",
	font = "Trebuchet24",
	padding = 10,
	offset = 30,
	fr_width = 0,
	colors = {
		normal = {
			text = Color(255, 255, 255, 255),
			background = Color(50, 50, 50, 100),
			frame = Color(70, 70, 70, 100),
		},
		highlighted = {
			text = Color(255, 255, 255, 255),
			background = Color(48, 131, 37, 154),
			frame = Color(70, 70, 70, 100),
		}
	}
}
TARDIS:AddTipStyle(style)
