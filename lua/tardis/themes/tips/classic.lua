local style={
    style_id="classic",
    style_name="Classic (Legacy)",
    font="GModWorldtip",
    padding = 10,
    offset = 30,
    fr_width = 2,
    colors = {
        normal = {
            text = Color(0, 0, 0, 255),
            background = Color(255, 255, 200, 255),
            frame = Color(0, 0, 0, 255),
        },
        highlighted = {
            text = Color(0, 0, 0),
            background = Color(138, 228, 111),
            frame = Color(0, 0, 0, 255),
        }
    }
}
TARDIS:AddTipStyle(style)
