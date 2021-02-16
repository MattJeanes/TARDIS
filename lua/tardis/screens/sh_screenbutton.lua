TardisScreenButton = {}

function TardisScreenButton:new(parent)
	local screen_button = {}

	screen_button.visible = true
	screen_button.icon = vgui.Create("DImageButton", parent)
	screen_button.label = vgui.Create("DLabel", parent)
	screen_button.label:SetColor(Color(255,255,255,0))
	screen_button.is_toggle = false
	screen_button.icon_off = "materials/vgui/tardis-desktops/default/default_off.png"
	screen_button.icon_on = "materials/vgui/tardis-desktops/default/default_on.png"
	screen_button.icon:SetImage(screen_button.icon_off)
	screen_button.Think = function() end

	function screen_button.icon:Think()
		if not screen_button.is_toggle and screen_button.on
			and CurTime() > screen_button.click_end_time
		then
			screen_button.icon:SetImage(screen_button.icon_off)
			screen_button.on = false
		end
		screen_button.Think()
	end


	screen_button.icon.DoClick = function()
		screen_button.DoClick()
		screen_button.on = not screen_button.on
		if screen_button.on then
			screen_button.icon:SetImage(screen_button.icon_on)
		else
			screen_button.icon:SetImage(screen_button.icon_off)
		end
		screen_button.click_end_time = CurTime() + 1
	end
	screen_button.label.DoClick = screen_button.icon.DoClick

	setmetatable(screen_button,self)
	self.__index = self
	return screen_button
end

function TardisScreenButton:SetSize(sizeX, sizeY)
	self.icon:SetSize(sizeX, sizeY)
	self.label:SetSize(sizeX, sizeY)
end

function TardisScreenButton:SetPos(posX, posY)
	self.icon:SetPos(posX, posY)
	self.label:SetPos(posX, posY)
end

function TardisScreenButton:SetImages(off, on)
	self.icon_off = off
	self.icon_on = on or off
	self.icon:SetImage(self.icon_off)
end

function TardisScreenButton:SetIsToggle(is_toggle)
	self.is_toggle=is_toggle
end

function TardisScreenButton:GetTall()
	return self.icon:GetTall()
end

function TardisScreenButton:GetWide()
	return self.icon:GetWide()
end

function TardisScreenButton:SetToggle(on)
	self.on = on
	if on then
		self.icon:SetImage(self.icon_on)
	else
		self.icon:SetImage(self.icon_off)
	end
end

function TardisScreenButton:SetVisible(visible)
	self.icon:SetVisible(visible)
	self.label:SetVisible(visible)
	self.visible = visible
end

function TardisScreenButton:GetVisible()
	return self.visible
end
