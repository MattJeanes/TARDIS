-- HUD

hook.Add("HUDPaint", "TARDISRewrite-HUD", function()
	if not TARDIS:GetSetting("health-enabled", true) then return end
	if not (LocalPlayer():GetTardisData("interior") or LocalPlayer():GetTardisData("exterior")) then return end
	local tardis = LocalPlayer():GetTardisData("exterior")
	if not IsValid(tardis) then return end
	local sw = ScrW()
	local sh = ScrH()
	local health = math.ceil(tardis:GetHealthPercent())
	local width = 115
	if health >= 10 then width = width + 10 end
	if health == 100 then width = width + 35 end
	local height = (sw >= 800) and 120 or 95
	local healthfont = (height == 120) and "TARDIS-Large" or "TARDIS-Med"
	local x = (ScrW()-width)*0.02
	local y = (ScrH()-height)*0.025
	draw.RoundedBox( 10, x, y, width, height, NamedColor("BgColor") )
	local textcolor
	local textcolor = (health > 0) and NamedColor("FgColor") or NamedColor("Caution")
	if (health > 20) then textcolor = NamedColor("FgColor")
	else textcolor = NamedColor("Caution") end
	draw.DrawText( "TARDIS", "TARDIS-PageName", x+10, y+10, textcolor, TEXT_ALIGN_LEFT )
	draw.DrawText( tostring(health) .. "%", healthfont, x+10, y+45, textcolor, TEXT_ALIGN_LEFT )
end)
