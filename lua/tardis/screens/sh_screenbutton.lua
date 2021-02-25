TardisScreenButton = {}

function TardisScreenButton:new(parent)
	local sb = {}

	sb.visible = true
	sb.transparency = 0
	sb.outside = false
	sb.parent = parent

	sb.icon = vgui.Create("DImageButton", parent)
	sb.label = vgui.Create("DLabel", parent)
	sb.label:SetColor(Color(255,255,255,0))
	sb.label:SetText("")
	sb.label:SetFont("TARDIS-Default")

	sb.is_toggle = false

	sb.theme_dir = TARDIS.visualgui_theme_basefolder
	sb.theme_dir = sb.theme_dir..TARDIS:GetSetting("visual_gui_theme").."/"
	sb.icon_off = sb.theme_dir.."default_off.png"
	sb.icon_on = sb.theme_dir.."default_on.png"

	sb.icon:SetImage(sb.icon_off)
	sb.on = false
	sb.pos = {0, 0}
	sb.size = {10, 10}

	sb.moving = {}
	sb.moving.now = false

	sb.toggle_images = false

	sb.Think = function() end
	sb.DoClick = function() end

	sb.SetVisibleCustom = function(vis)
		if vis then
			sb.transparency = 255
		else
			sb.transparency = 0
		end
	end

	sb.ThinkInternal = function()
		sb.transparency = math.min(sb.transparency, 255)
		sb.transparency = math.max(sb.transparency, 0)
		if not sb.is_toggle and sb.on and CurTime() > sb.click_end_time then
			sb.icon:SetImage(sb.icon_off)
			sb.on = false
		end
		if sb.moving.now then
			sb.moving.move()
			sb.icon:SetColor(Color(255, 255, 255, sb.transparency))
			sb.label:SetColor(Color(0, 0, 0, sb.transparency))
		end

		local realpos = { math.min(math.max(sb.pos[1], 0), sb.parent:GetWide() - sb.size[1]),
						  math.min(math.max(sb.pos[2], 0), sb.parent:GetTall() - sb.size[2]) }
		sb.icon:SetPos(realpos[1], realpos[2])
		sb.label:SetPos(sb.pos[1], sb.pos[2])
		sb.icon:SetSize(sb.size[1], sb.size[2])
		sb.label:SetSize(sb.size[1], sb.size[2])
		if not sb.moving.now then
			sb.outside = (sb.pos[1] < 0) or (sb.pos[2] < 0)
				or (sb.pos[1] + sb.size[1] > sb.parent:GetWide())
				or (sb.pos[2] + sb.size[2] > sb.parent:GetTall())
			sb.SetVisibleCustom(not sb.outside)
		end
		sb.Think()
	end

	sb.DoClickInternal = function()
		if sb.is_toggle then
			sb.DoClick()
			sb.on = not sb.on
			if sb.toggle_images then
				if sb.on then
					sb.icon:SetImage(sb.icon_on)
				else
					sb.icon:SetImage(sb.icon_off)
				end
			end
		else
			if not sb.on then
				sb.DoClick()
				sb.on = true
				sb.icon:SetImage(sb.icon_on)
				sb.click_end_time = CurTime() + 0.5
			end
		end
	end

	sb.icon.Think = sb.ThinkInternal
	sb.label.Think = sb.ThinkInternal
	sb.icon.DoClick = sb.DoClickInternal
	sb.label.DoClick = sb.DoClickInternal
	sb.ThinkInternal()

	setmetatable(sb,self)
	self.__index = self
	return sb
end

function TardisScreenButton:Think()
	self.ThinkInternal()
end

function TardisScreenButton:SetSize(sizeX, sizeY)
	self.size = {sizeX, sizeY}
	self.ThinkInternal()
end

function TardisScreenButton:SetPos(posX, posY)
	if posY == nil then
		self.pos = {posX, 0}
	else
		self.pos = {posX, posY}
	end
	self.ThinkInternal()
end

function TardisScreenButton:SetText(text)
	local theme = self.theme_dir
	local file_on = theme.."on/"..text..".png"
	local file_off = theme.."off/"..text..".png"

	if file.Exists(file_on, "GAME") and file.Exists(file_off, "GAME") then
		self:SetImages(file_off, file_on)
	elseif file.Exists(file_off, "GAME") then
		self:SetImages(file_off)
	else
		self.label:SetColor(Color(0,0,0,255))
		self.label:SetText("   "..text)
	end
end

function TardisScreenButton:SetFont(font)
	self.label:SetFont(font)
end

function TardisScreenButton:GetPosX()
	return self.pos[1]
end
function TardisScreenButton:GetPosY()
	return self.pos[2]
end
function TardisScreenButton:GetWide()
	return self.size[1]
end
function TardisScreenButton:GetTall()
	return self.size[2]
end
function TardisScreenButton:GetSize()
	return self.size[1], self.size[2]
end

function TardisScreenButton:SetImages(off, on)
	self.icon_off = off
	self.icon_on = on or off
	self.icon:SetImage(self.icon_off)
end

function TardisScreenButton:SetIsToggle(is_toggle)
	self.is_toggle=is_toggle
end

function TardisScreenButton:SetPressed(on)
	self.on = on
	if on then
		self.icon:SetImage(self.icon_on)
	else
		self.icon:SetImage(self.icon_off)
	end
end
function TardisScreenButton:IsPressed()
	return self.on
end

function TardisScreenButton:SetVisible(visible)
	self.visible = visible
	self.icon:SetVisible(visible)
	self.label:SetVisible(visible)
end

function TardisScreenButton:IsVisible()
	return self.visible
end

function TardisScreenButton:SetTransparency(x)
	self.transparency = x
end

function TardisScreenButton:SetControl(control)
	self.DoClick = function()
		TARDIS:Control(control)
	end
end

function TardisScreenButton:SetPressedStateData(ext, data1, data2)
	if data2 == nil then
		self.Think = function()
			self:SetPressed(ext:GetData(data1))
		end
	else
		self.Think = function()
			self:SetPressed(ext:GetData(data1) or ext:GetData(data2))
		end
	end
end

function TardisScreenButton:InitiateMove(x, y, relative, speed)
	if self.moving.now then return end

	local moving = {}
	moving.now = true
	moving.parent = self
	moving.speed = speed or 100

	if relative then
		moving.aim = { self.pos[1] + x, self.pos[2] + y }
	else
		moving.aim = { x, y }
	end

	moving.now_outside = (self.pos[1] < 0) or (self.pos[2] < 0)
		or (self.pos[1] + self.size[1] > self.parent:GetWide())
		or (self.pos[2] + self.size[2] > self.parent:GetTall())

	moving.aim_outside = (moving.aim[1] < 0) or (moving.aim[2] < 0)
		or (moving.aim[1] + self.size[1] > self.parent:GetWide())
		or (moving.aim[2] + self.size[2] > self.parent:GetTall())

	if moving.aim_outside then
		moving.transp_aim = 0
	else
		moving.transp_aim = 255
	end

	moving.move = function()
		local sb = moving.parent
		sb.pos[1] = math.Approach(sb.pos[1], moving.aim[1], moving.speed * FrameTime())
		sb.pos[2] = math.Approach(sb.pos[2], moving.aim[2], moving.speed * FrameTime())
		sb.transparency = math.Approach(sb.transparency, moving.transp_aim, moving.speed * FrameTime() * 1.5)
		if sb.pos[1] == moving.aim[1] and sb.pos[2] == moving.aim[2] and sb.transparency == moving.transp_aim then
			moving.now = false
		end
	end
	self.moving = moving
end
