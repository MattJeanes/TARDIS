//TARDIS HUD

function TARDISHUD()
    if not (LocalPlayer():GetTardisData("interior") or LocalPlayer():GetTardisData("exterior")) then return end
    local tardis = LocalPlayer():GetTardisData("exterior")
    if not IsValid(tardis) then return end
    local width = 160
    local height = 120
    local x = (ScrW()-width)*0.02
    local y = (ScrH()-height)*0.025
    draw.RoundedBox( 10, x, y, width, height, NamedColor("BgColor") )
    local textcolor = (tardis:GetData("health-val", 0) > 0) and NamedColor("FgColor") or NamedColor("Caution")
    draw.DrawText( "TARDIS", "TARDIS-PageName", x+10, y+10, textcolor, TEXT_ALIGN_LEFT )
    draw.DrawText( tardis:GetData("health-val",0), "TARDIS-Large", x+10, y+45, textcolor, TEXT_ALIGN_LEFT )
end

hook.Add("HUDPaint", "TARDISRewrite-HUD", TARDISHUD)