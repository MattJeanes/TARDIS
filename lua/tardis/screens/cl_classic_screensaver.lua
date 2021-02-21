
TARDIS:AddScreen("Classic Screensaver", {menu=false, notitle=true}, function(self,ext,int,frame,screen)

	frame:SetBackgroundColor(Color(0,0,128,255))

	local background=vgui.Create("DImage", frame)
	background:SetImage("materials/vgui/screensaver_background.jpg")
	background:SetSize(frame:GetWide(), frame:GetTall())

	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(255,255,255))
	label:SetFont("TARDIS-Main")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText([[ TARDIS Rewrite
	Work In Progress]])
	label:DoLayout()

	local showui = vgui.Create("DButton",frame)
	showui:SetText("Open UI")
	showui:SetFont("TARDIS-Default")
	showui:SetSize(frame:GetWide()*0.2,frame:GetTall()*0.1)
	showui:SetPos((frame:GetWide()*0.5)-(showui:GetWide()*0.5),(frame:GetTall()*0.8)-(showui:GetTall()*0.5))
	showui.DoClick = function(self)
		--background:SetVisible(false)
		--TARDIS:SwitchScreen(self, screen)
		screen.menubutton:DoClick()
	end
end)
