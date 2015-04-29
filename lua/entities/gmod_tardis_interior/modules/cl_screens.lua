-- Adds screens

surface.CreateFont("TARDIS-Main", {
	font="Roboto",
	size=50
})

surface.CreateFont("TARDIS-Large", {
	font="Roboto",
	size=40
})

ENT:AddHook("Initialize", "screens", function(self)

	-- Screen 1
	local screen = vgui.Create("DPanel")
	screen.id="screen"
	screen:SetPos( 0, 0 )
	screen:SetSize( 485,250 )
	screen:SetPaintedManually(true)
	screen:SetDrawBackground(false)
	
	main = vgui.Create("DPanel",screen)
	main.id="main"
	main:SetVisible(false)
	main:SetSize(screen:GetWide()-10, screen:GetTall()-10)
	main:SetPos(5,5)
	main:SetAlpha(230)
	
	local label = vgui.Create("DLabel",screen)
	label.id="wip"
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Main")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((screen:GetWide()*0.5)-(label:GetWide()*0.5),(screen:GetTall()*0.4)-(label:GetTall()*0.5))
	end
	label:SetText([[ TARDIS Rewrite
	Work In Progress]])
	label:DoLayout()
	
	local button = vgui.Create("DButton",screen)
	button.id="testui"
	button.text="Show Test UI"
	button:SetText(button.text)
	button:SetSize(200,30)
	button:SetPos((screen:GetWide()*0.5)-(button:GetWide()*0.5),(screen:GetTall()*0.8)-(button:GetTall()*0.5))
	button.DoClick = function(self)
		if self:GetText()==self.text then
			self:SetText("Hide Test UI")
			label:SetVisible(false)
			main:SetVisible(true)
		else
			self:SetText(self.text)
			label:SetVisible(true)
			main:SetVisible(false)
		end
		label:DoLayout()
	end
	
	local label = vgui.Create("DLabel",main)
	label.id="interface"
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Large")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((main:GetWide()*0.5)-(label:GetWide()*0.5),(main:GetTall()*0.15)-(label:GetTall()*0.5))
	end
	label:SetText("TARDIS Interface")
	label:DoLayout()

	local label = vgui.Create("DLabel",main)
	label.id="doorstatus"
	label:SetTextColor(Color(0,0,0))
	label:SetFont("DermaLarge")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((main:GetWide()*0.5)-(label:GetWide()*0.5),(main:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	
	local button = vgui.Create("DButton",main)
	button.id="toggledoor"
	button.open=nil
	button:SetSize(200,30)
	button:SetPos((main:GetWide()*0.5)-(button:GetWide()*0.5),(main:GetTall()*0.5)-(button:GetTall()*0.5))
	button.DoClick = function(button)
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
			ext:Control("toggledoor")
		end
	end
	button.Think = function(button)
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
			if ext:DoorMoving() then
				if not button:GetDisabled() then
					if button.open then
						label:SetText("The door is closing")
					else
						label:SetText("The door is opening")
					end
					label:DoLayout()
					button:SetDisabled(true)
				end
			elseif button:GetDisabled() then
				button:SetDisabled(false)
			elseif ext:DoorOpen() and not button.open then
				button.open=true
				button:SetText("Close the door")
				label:SetText("The door is open")
				label:DoLayout()
			elseif not ext:DoorOpen() and button.open then
				button.open=false
				button:SetText("Open the door")
				label:SetText("The door is closed")
				label:DoLayout()
			end
		end
	end
	
	-- Screen 2
	self.screen1=screen
	
	local screen = vgui.Create( "DPanel" )
	screen:SetPos( 0, 0 )
	screen:SetSize( 485,250 )
	screen:SetPaintedManually(true)
	screen:SetDrawBackground(false)
	
	local label = vgui.Create("DLabel",screen)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Main")
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
	vgui.Start3D2D(self:LocalToWorld(Vector(31.7,-30,162.6)),self:LocalToWorldAngles(Angle(0,58.8,90)),0.06)
		draw.RoundedBox(0,0,0,485,250,col)
		self.screen1:Paint3D2D()
	vgui.End3D2D()
	
	vgui.Start3D2D(self:LocalToWorld(Vector(-32.6,37.4,163.55)),self:LocalToWorldAngles(Angle(0,-120,90)),0.06)
		draw.RoundedBox(0,0,0,485,250,col)
		self.screen2:Paint3D2D()
	vgui.End3D2D()
end)