-- HUD

surface.CreateFont("TARDIS-HUD-Large", {
    font="Roboto",
    size=58
})

surface.CreateFont("TARDIS-HUD-Med", {
    font="Roboto",
    size=36
})

surface.CreateFont("TARDIS-HUD-Small", {
    font="Roboto",
    size=30
})

local fgcolor = NamedColor("FgColor")
local red = NamedColor("Caution")
local bgcolor = NamedColor("BgColor")

local function CreatePercentageHUDPanel(text, value, offset, red_level)
    local width = 115
    local height = (ScrW() >= 800) and 95 or 85

    if value >= 10 then width = width + 10 end
    if value == 100 then width = width + 20 end

    local x = (ScrW() - width) * 0.02 + offset
    local y = (ScrH() - height) * 0.025

    local value_font = (height == 95) and "TARDIS-HUD-Large" or "TARDIS-HUD-Med"
    local textcolor = (value > red_level) and fgcolor or red

    draw.RoundedBox( 10, x, y, width, height, bgcolor )
    draw.DrawText( text, "TARDIS-HUD-Small", x+10, y+10, textcolor, TEXT_ALIGN_LEFT )
    draw.DrawText( tostring(value) .. "%", value_font, x+10, y+35, textcolor, TEXT_ALIGN_LEFT )

    return width, height
end

hook.Add("HUDPaint", "TARDIS-HUD", function()
    local ply = LocalPlayer()
    if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end
    local tardis = ply:GetTardisData("exterior")
    if not tardis then return end

    local draw_health = TARDIS:GetSetting("health-enabled")
    local draw_artron = TARDIS:GetSetting("artron_energy")

    if not draw_health and not draw_artron then return end

    if not IsValid(tardis) then return end

    local offset = 0

    if draw_health then
        offset,_ = CreatePercentageHUDPanel(
            TARDIS:GetPhrase("Common.TARDIS"),
            math.ceil(tardis:GetHealthPercent()),
            0, 20
        )
    end

    if draw_artron then
        local val = tardis:GetData("artron-val", 0)
        local percent = val * 100 / TARDIS:GetSetting("artron_energy_max")

        CreatePercentageHUDPanel(TARDIS:GetPhrase("Common.Artron"),
            math.ceil(percent), offset + 10, 10
        )
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

