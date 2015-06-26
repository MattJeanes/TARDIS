-- Settings

TARDIS_AddScreen("Settings", function(self,frame)
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Large")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.5)-(label:GetTall()*0.5))
	end
	label:SetText("Coming soon")
	label:DoLayout()
end)