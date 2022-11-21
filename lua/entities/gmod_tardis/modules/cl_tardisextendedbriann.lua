print("Running Client Tardis Extensions")

hook.Add("HUDPaint", "TARDIS-HUD2", function()
    if not TARDIS:GetSetting("health-enabled") then return end
    if not (LocalPlayer():GetTardisData("interior") or LocalPlayer():GetTardisData("exterior")) then return end
    local tardis = LocalPlayer():GetTardisData("exterior")
    if not IsValid(tardis) then return end
    local sw = ScrW()
    local sh = ScrH()
    local val = tardis:GetData("artron-val", 0)
    local percent = val * 100 / TARDIS:GetSetting("artron_energy_max")
    local health = math.ceil(percent)

    local width = 115
    if health >= 10 then width = width + 10 end
    if health == 100 then width = width + 35 end
    local height = (sw >= 800) and 120 or 95
    local healthfont = (height == 120) and "TARDIS-HUD-Large" or "TARDIS-HUD-Med"
    local x = (ScrW()-width)*0.02
    local y = (ScrH()-height)*0.025
    draw.RoundedBox( 10, x + 190, y, width, height, NamedColor("BgColor") )
    local textcolor
    local textcolor = (health > 0) and NamedColor("FgColor") or NamedColor("Caution")
    if (health > 20) then textcolor = NamedColor("FgColor")
    else textcolor = NamedColor("Caution") end
    draw.DrawText( TARDIS:GetPhrase("ARTRON"), "TARDIS-HUD-Small", x+200, y+10, textcolor, TEXT_ALIGN_LEFT )
    draw.DrawText( tostring(health) .. "%", healthfont, x+200, y+45, textcolor, TEXT_ALIGN_LEFT )
end)

list.Set("DesktopWindows", "TardisHUD2", {
    title = "TARDIS",
    icon = "materials/vgui/tardis_context_menu.png",
    init = function()
        local ext = LocalPlayer():GetTardisData("exterior")
        if IsValid(ext) then
            TARDIS:HUDScreen()
        else
            TARDIS:ErrorMessage(LocalPlayer(), "Common.NotInTARDIS")
        end
    end
})



