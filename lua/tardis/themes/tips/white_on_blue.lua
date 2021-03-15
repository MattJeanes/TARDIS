local style = {
	style_id = "white_on_blue",
	style_name = "white on blue",
	font = "Trebuchet24",
	colors = {
		normal = {
			text = Color(255, 255, 255, 255),
			background = Color(10, 10, 255, 140),
			frame = Color(10, 10, 50, 100),
		},
		highlighted = {
			text = Color(255, 255, 255, 255),
			background = Color(36, 173, 18, 140),
			frame = Color(10, 10, 50, 100),
		}
	}
}
TARDIS:AddTipStyle(style)
