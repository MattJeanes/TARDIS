-- Test screen

ENT:AddScreen("Test", function(self,frame)
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Large")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.15)-(label:GetTall()*0.5))
	end
	label:SetText("Test Menu")
	label:DoLayout()
	
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("DermaLarge")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Try the menu button")
	label:DoLayout()
	
	local sprite = vgui.Create( "DSprite",frame )
	sprite:SetMaterial(Material("icon16/emoticon_smile.png"))
	sprite:SetSize(frame:GetWide()*0.3,frame:GetWide()*0.3)
	sprite:SetPos(frame:GetWide()/2,(frame:GetTall()/2)+(sprite:GetTall()*0.25))
end)

--for i=1,70 do ENT:AddScreen("test-"..i, function(self,frame) end) end