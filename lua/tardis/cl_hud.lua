-- HUD

local m, x_offset, y_offset, width, height, x, y, icon_size, number_offset

local function UpdateHudFont()
    surface.CreateFont("TARDIS-HUD", {
        font="HalfLife2",
        size= ScrH() / 14.4
    })

    surface.CreateFont("TARDIS-HUD-Glow", {
        font="HalfLife2",
        size = ScrH() / 14.4 + 4,
        scanlines = 3,
        antialias = true,
        additive = true,
        blursize = 6,
        weight = 10,
    })

    m = ScrH() / 900 -- optimize calculations
    x_offset = 20 * m
    y_offset = 55 * m
    y_offset_2 = y_offset * 0.5
    y_offset_3 = y_offset * 0.27
    width = 155 * m
    height = 45 * m
    x = ScrW() * 0.02
    y = ScrH() * 0.025
    icon_size = 25 * m
    number_offset = 35 * m
end

hook.Add("OnScreenSizeChanged", "TARDIS-HUD", UpdateHudFont)

UpdateHudFont()

local fgcolor = NamedColor("FgColor")
local red = NamedColor("Caution")
local bgcolor = NamedColor("BgColor")
local health_icon = Material("vgui/tardis_health.png")
local energy_icon=  Material("vgui/tardis_energy.png")

local function DrawNumber(icon_mat, value, red_level, x, y)
    local bad = (value < red_level)

    local textcolor = fgcolor

    if bad then
        local alpha = 255 * (0.5 + 0.1 * math.sin(CurTime() * 8))
        textcolor = Color(red.r, red.g, red.b, alpha)
    end

    surface.SetMaterial(icon_mat)
    surface.SetDrawColor(textcolor)

    surface.DrawTexturedRect( x, y + icon_size, icon_size, icon_size)

    draw.DrawText( tostring(value), "TARDIS-HUD", x + number_offset, y, textcolor, TEXT_ALIGN_LEFT)

    if bad then
        draw.DrawText( tostring(value), "TARDIS-HUD-Glow", x + number_offset - 2, y - 2, textcolor, TEXT_ALIGN_LEFT)
    end
end

hook.Add("HUDPaint", "TARDIS-HUD", function()
    local ply = LocalPlayer()
    if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end
    local tardis = ply:GetTardisData("exterior")
    if not IsValid(tardis) then return end

    local draw_health = TARDIS:GetSetting("health-enabled")
    local draw_artron = TARDIS:GetSetting("artron_energy")

    local count = 0
    if draw_health then count = count + 1 end
    if draw_artron then count = count + 1 end
    if count == 0 then return end

    local yc = y

    draw.RoundedBox( 10, x, y, width, height + y_offset * count, bgcolor )
    draw.DrawText(TARDIS:GetPhrase("Common.TARDIS"), "HudDefault", x + x_offset, y + y_offset_3, fgcolor, TEXT_ALIGN_LEFT )
    yc = yc + y_offset_2

    if draw_health then
        DrawNumber(health_icon, math.ceil(tardis:GetHealthPercent()), 20, x + x_offset, yc)
        yc = yc + y_offset
    end
    if draw_artron then
        DrawNumber(energy_icon, math.ceil(tardis:GetArtron()), TARDIS:GetSetting("artron_energy_max") * 0.1, x + x_offset, yc)
        yc = yc + y_offset
    end
end)

list.Set("DesktopWindows", "TardisHUD", {
    title = "TARDIS",
    icon = "materials/vgui/tardis_context_menu.png",
    init = function(icon, window)
        local ext = LocalPlayer():GetTardisData("exterior")
        if IsValid(ext) then
            TARDIS:HUDScreen(window)
        else
            TARDIS:ErrorMessage(LocalPlayer(), "Common.NotInTARDIS")
        end
    end
})

