-- Destination

TARDIS:AddControl("destination",{
	func=function(self,ply)
		self:SelectDestination(ply, true)
	end,
	exterior=true,
	serveronly=true
})

if SERVER then return end

TARDIS:AddScreen("Destination", {menu=false}, function(self,ext,int,frame,screen)
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Med")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Press to select destination")
	label:DoLayout()
	
	local button=vgui.Create("DButton",frame)
	button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	button:SetPos(frame:GetWide()*0.5 - button:GetWide()*0.5,frame:GetTall()*0.7 - button:GetTall()*0.5)
	button:SetText("Go")
	button:SetFont("TARDIS-Default")
	button.DoClick = function()
		TARDIS:Control("destination")
		if TARDIS:HUDScreenOpen(ply) then TARDIS:RemoveHUDScreen() end
	end
end)