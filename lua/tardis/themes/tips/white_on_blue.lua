local style = {
    style_id = "white_on_blue",
    style_name = "WhiteOnBlue",
    font = "Trebuchet24",
    padding = 10,
    offset = 30,
    fr_width = 0,
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
