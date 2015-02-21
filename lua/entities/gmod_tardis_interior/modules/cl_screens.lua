-- Adds screens

ENT:AddHook("Initialize", "screens", function(self)
	local screen = vgui.Create("DPanel")
	screen:SetPos( 0, 0 )
	screen:SetSize( 291, 150 )
	screen:SetPaintedManually(true)
	screen:SetDrawBackground(false)
	
	local label = vgui.Create("DLabel",screen)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("DermaLarge")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((screen:GetWide()*0.5)-(label:GetWide()*0.5),(screen:GetTall()*0.4)-(label:GetTall()*0.5))
	end
	label:SetText([[ TARDIS Rewrite
	Work In Progress]])
	label:DoLayout()
	
	local button = vgui.Create("DButton",screen)
	button:SetText("Test button")
	button:SetSize(200,30)
	button:SetPos((screen:GetWide()*0.5)-(button:GetWide()*0.5),(screen:GetTall()*0.8)-(button:GetTall()*0.5))
	button.DoClick = function(self)
		local text="Test button works!"
		if label:GetText()==text then
			label:SetText([[ TARDIS Rewrite
			Work In Progress]])
		else
			label:SetText("Test button works!")
		end
		label:DoLayout()
	end
	
	self.screen1=screen
	
	local screen = vgui.Create( "DPanel" )
	screen:SetPos( 0, 0 )
	screen:SetSize( 291, 150 )
	screen:SetPaintedManually(true)
	screen:SetDrawBackground(false)
	
	local label = vgui.Create("DLabel",screen)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("DermaLarge")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((screen:GetWide()*0.5)-(label:GetWide()*0.5),(screen:GetTall()*0.5)-(label:GetTall()*0.5))
	end
	label:SetText([[ TARDIS Rewrite
	Work In Progress]])
	label:DoLayout()
	
	self.screen2=screen
end)

ENT:AddHook("OnRemove", "screens", function(self)
	self.screen1:Remove()
	self.screen2:Remove()
end)
	
ENT:AddHook("Draw", "screens", function(self)
	local col=HSVToColor(180+math.sin(CurTime()*0.1)*180,0.5,1)
	vgui.Start3D2D(self:LocalToWorld(Vector(31.7,-30,162.6)),self:LocalToWorldAngles(Angle(0,58.8,90)),0.1)
		draw.RoundedBox(0,0,0,291,150,col)
		self.screen1:Paint3D2D()
	vgui.End3D2D()
	
	vgui.Start3D2D(self:LocalToWorld(Vector(-32.6,37.4,163.55)),self:LocalToWorldAngles(Angle(0,-120,90)),0.1)
		draw.RoundedBox(0,0,0,291,150,col)
		self.screen2:Paint3D2D()
	vgui.End3D2D()
end)