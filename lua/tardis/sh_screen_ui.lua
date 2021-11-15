-- Adds screens

function TARDIS:HUDScreenOpen(ply)
	if SERVER then
		return ply.TARDISHUDScreen
	else
		return self.HUDScreenActive
	end
end

function TARDIS:PopToScreen(name, ply)
	if SERVER then
		if IsValid(ply) and ply:IsPlayer() then
			net.Start("TARDIS-PopToScreen")
				net.WriteString(name)
			net.Send(ply)
		end
	else
		self:HUDScreen()
		self:SwitchScreen(self.screenpop, self:GetScreenByName(name))
	end
end

if SERVER then
	TARDIS:LoadFolder("screens")
	util.AddNetworkString("TARDIS-HUDScreen")
	util.AddNetworkString("TARDIS-PopToScreen")
	net.Receive("TARDIS-HUDScreen",function(len,ply)
		ply.TARDISHUDScreen=net.ReadBool()
	end)
	return
end

TARDIS.fonts = {}
TARDIS.fontcache = {}
function TARDIS:GetScreenFont(screen, name)
	local scale = screen.res * screen.resscale
	if not self.fontcache[scale] then self.fontcache[scale] = {} end
	local fontCached = self.fontcache[scale][name]
	local fontName = "TARDIS_" .. tostring(scale) .. "_" .. name
	if not fontCached then
		local font = self.fonts[name]
		if not font then error("TARDIS font '"..name.."' is not defined") end
		local fontCopy = table.Copy(font)
		fontCopy.size = math.Round(font.size * scale, 2)
		print("Generating TARDIS font ".. name .. " with size " .. tostring(fontCopy.size))
		surface.CreateFont(fontName, fontCopy)
		self.fontcache[scale][name] = true
	end
	return fontName
end

function TARDIS:CreateScreenFont(name, font)
	self.fonts[name] = font
end

TARDIS:CreateScreenFont("Default", {
	font="Tahoma",
	size=13
})

TARDIS:CreateScreenFont("Main", {
	font="Roboto",
	size=50
})

TARDIS:CreateScreenFont("Large", {
	font="Roboto",
	size=40
})

TARDIS:CreateScreenFont("Med", {
	font="Roboto",
	size=24
})

TARDIS:CreateScreenFont("PageName", {
	font="Roboto",
	size=20
})

TARDIS:AddKeyBind("tp-openscreen",{
	name="Open Screen",
	section="Third Person",
	desc="Toggles the HUD screen",
	func=function(self,down,ply)
		if down and ply:GetTardisData("outside") then
			TARDIS:HUDScreen()
		end
	end,
	key=MOUSE_MIDDLE,
	clientonly=true,
	exterior=true
})

local screens={}
function TARDIS:AddScreen(name,options,func)
	screens[name]={options,func}
end
TARDIS:LoadFolder("screens")

function TARDIS:GetScreens()
	return screens
end

function TARDIS:ScreenActive(name)
	local int=TARDIS:GetInteriorEnt()
	local t={}
	if IsValid(int) then
		if int.screens3D then
			for k,v in pairs(int.screens3D) do
				if IsValid(v) and IsValid(v.curscreen) and v.frame:IsVisible() and v.curscreen._name==name then
					table.insert(t,v)
				end
			end
		end
	end
	local pop=self.screenpop
	if IsValid(pop) and IsValid(pop.curscreen) and pop.frame:IsVisible() and pop.curscreen._name==name then
		table.insert(t,pop)
	end
	if #t>0 then
		return t
	end
end

function TARDIS:GetScreenFrames()
	if not self.HUDScreenActive or not IsValid(self.screenpop) then return end
	local tab = {}

	for k,v in pairs(self.screenpop.screens) do
		tab[v[1]] = v[2]
	end

	return tab
end

function TARDIS:GetScreenByName(name)
	if not self.HUDScreenActive or not IsValid(self.screenpop) then return end
	local screen = self:GetScreenFrames()[name]
	if not IsValid(screen) then return end
	return screen
end

function TARDIS:SwitchScreen(screen,newscreen)
	if IsValid(newscreen) then
		if #screen.backstack>0 then
			self:PopScreen(screen,true)
		end
		if IsValid(screen.curscreen) then
			screen.curscreen:SetVisible(false)
		end
		newscreen:SetVisible(true)
		screen.curscreen=newscreen
		screen.pagename:SetText(tostring(newscreen._name))
		screen.pagename:DoLayout()
		if IsValid(screen.mmenu) then
			screen.mmenu:SetVisible(false)
			if TARDIS:GetSetting("visgui_enabled") then
				screen.left_arrow:SetVisible(false)
				screen.right_arrow:SetVisible(false)
			end
		end
	end
end

net.Receive("TARDIS-PopToScreen", function(len)
	local name = net.ReadString()
	TARDIS:PopToScreen(name)
end)

function TARDIS:PopScreen(screen,all)
	if #screen.backstack>0 then
		local info=screen.backstack[#screen.backstack]
		info.f2:SetVisible(false)
		info.f:SetVisible(true)
		local pagename=screen.pagename
		pagename:SetText(info.oldname)
		pagename:DoLayout()
		table.remove(screen.backstack)
		if #screen.backstack==0 then
			screen.backbutton:SetVisible(false)
		elseif all then
			self:PopScreen(screen,all)
		end
	end
end

function TARDIS:PushScreen(name,screen,f,f2)
	local titlebar=screen.titlebar
	local pagename=screen.pagename
	local oldname=pagename:GetText()
	f:SetVisible(false)
	f2:SetVisible(true)
	pagename:SetText(oldname.."/"..name)
	pagename:DoLayout()
	table.insert(screen.backstack,
		{
			f=f,
			f2=f2,
			oldname=oldname
		}
	)
	if not screen.backbutton:IsVisible() then
		screen.backbutton:SetVisible(true)
		if TARDIS:GetSetting("visgui_enabled") then
			screen.left_arrow:SetVisible(false)
			screen.right_arrow:SetVisible(false)
		end
	end
end

function TARDIS:RemoveHUDScreen()
	if IsValid(self.screenpopframe) then
		local curscreen = self.screenpop.curscreen
		if IsValid(curscreen) and curscreen.OnCloseScreen then
			local result = curscreen:OnCloseScreen()
			if result == false then
				return
			end
		end
		self.screenpopframe:Remove()
		self.screenpopframe=nil
		if timer.Exists("TARDIS-HUDScreen") then
			timer.Remove("TARDIS-HUDScreen")
		end
		timer.Create("TARDIS-HUDScreen",0.5,1,function()
			TARDIS.HUDScreenActive=false
			net.Start("TARDIS-HUDScreen")
				net.WriteBool(false)
			net.SendToServer()
		end)
	end
end

function TARDIS:HUDScreen()
	if IsValid(self.screenpopframe) then
		self:RemoveHUDScreen()
		return
	end

	local frame=vgui.Create("DFrame")
	frame:SetSkin("TARDIS")
	frame:SetTitle("TARDIS Interface")
	frame:SetDraggable(true)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	self.screenpopframe=frame

	local screen = vgui.Create("DPanel",frame)
	screen.id="pop"
	screen.width=825
	screen.height=425

	if TARDIS:GetSetting("visgui_enabled") and TARDIS:GetSetting("visgui_bigpopup") then
		screen.width=screen.width*1.5
		screen.height=screen.height*1.5
	end

	screen.resscale = 0.7
	screen.res=screen.width/485
	screen.crosshair=6*screen.res
	screen.gap=5*screen.res
	screen.gap2=screen.gap*2
	screen.ext=TARDIS:GetExteriorEnt()
	screen.int=TARDIS:GetInteriorEnt()
	screen:SetSize(screen.width,screen.height)
	screen:SetPos(2,25)
	self:LoadScreenUI(screen)
	local x,y=screen:GetSize()
	screen:SetSize(x-screen.gap2,y-screen.gap2)
	local x,y=screen:GetSize()
	frame:SetSize(x+4,y+27)
	frame:Center()
	self.screenpop=screen

	if timer.Exists("TARDIS-HUDScreen") then
		timer.Remove("TARDIS-HUDScreen")
	end
	self.HUDScreenActive=true
	net.Start("TARDIS-HUDScreen")
		net.WriteBool(true)
	net.SendToServer()
end
concommand.Add("tardis2_toggleui", function()
	TARDIS:HUDScreen()
end)

function TARDIS:LoadScreenUI(screen)
	local theme = TARDIS:GetSetting("visgui_theme")
	local background_img = TARDIS:GetGUIThemeElement(theme, "backgrounds", "main")

	local frame = vgui.Create("DPanel", screen)
	frame:SetSize(screen:GetWide() - screen.gap2, screen:GetTall() - screen.gap2)
	screen.frame=frame

	screen.backstack={}

	if TARDIS:GetSetting("visgui_enabled") then
		frame:SetBackgroundColor(Color(0,0,0,255))
		local frame_background=vgui.Create("DImage", frame)
		frame_background:SetImage(background_img)
		frame_background:SetSize( frame:GetWide(), frame:GetTall() )
	end

	local titlebar = vgui.Create("DPanel",frame)
	if TARDIS:GetSetting("visgui_enabled") then
		titlebar:SetSize(frame:GetWide(), frame:GetTall() * 0.15)
		titlebar:SetPos(0, frame:GetTall() - titlebar:GetTall() )
		titlebar:SetBackgroundColor(Color(1, 1, 100, 255))
	else
		titlebar:SetSize(frame:GetWide(), frame:GetTall() * 0.1)
		titlebar:SetPos(0, 0)
		titlebar:SetBackgroundColor(Color(220,220,220))
	end

	local pagename = vgui.Create("DLabel",titlebar)
	if TARDIS:GetSetting("visgui_enabled") then
		pagename:SetTextColor(Color(255,255,255))
	else
		pagename:SetTextColor(Color(0,0,0))
	end
	pagename:SetFont(TARDIS:GetScreenFont(screen, "PageName"))
	pagename.DoLayout = function(self)
		pagename:SizeToContents()
		pagename:SetPos((titlebar:GetWide()*0.5)-(pagename:GetWide()*0.5), (titlebar:GetTall()*0.5)-(pagename:GetTall()*0.5))
	end
	pagename:SetText("")
	pagename:DoLayout()
	screen.pagename=pagename

	local main = vgui.Create("DPanel",frame)
	main:SetSize(frame:GetWide(),frame:GetTall() - titlebar:GetTall())
	if TARDIS:GetSetting("visgui_enabled") then
		main:SetPos(0,0)
		main:SetBackgroundColor(Color(0,0,0,255))
	else
		main:SetPos(0, titlebar:GetTall())
	end
	screen.main=main

	local mmenu = vgui.Create("DPanel",main)
	mmenu:SetSize(main:GetSize())
	mmenu:SetPos(0,0)
	mmenu:SetBackgroundColor(Color(0,0,0,255))
	local mmenu_background=vgui.Create("DImage", mmenu)
	mmenu_background:SetImage(background_img)
	mmenu_background:SetSize( mmenu:GetWide(), mmenu:GetTall() )
	screen.mmenu=mmenu

	local backbutton, menubutton, popup_button

	if TARDIS:GetSetting("visgui_enabled") then
		titlebar.button_size = math.min(titlebar:GetTall() * 0.8, titlebar:GetWide() * 0.25)
		titlebar.button_posY = titlebar:GetTall() * 0.5 - titlebar.button_size * 0.5

		local left1 = 0.3 * titlebar.button_size
		local left2 = 2.6 * titlebar.button_size
		local right1 = titlebar:GetWide() - 2.3 * titlebar.button_size
		local right2 = titlebar:GetWide() - 4.6 * titlebar.button_size

		menubutton = TardisScreenButton:new(titlebar,screen)
		menubutton:SetID("menu")
		menubutton:SetFrameType(0, 1)
		menubutton:SetSize(titlebar.button_size * 2, titlebar.button_size)
		menubutton:SetPos(left1, titlebar.button_posY)
		menubutton:SetIsToggle(false)

		backbutton = TardisScreenButton:new(titlebar,screen)
		backbutton:SetID("back")
		backbutton:SetFrameType(0, 1)
		backbutton:SetSize(titlebar.button_size * 2, titlebar.button_size)
		backbutton:SetPos(left2, titlebar.button_posY)
		backbutton:SetIsToggle(false)

		popup_button = TardisScreenButton:new(titlebar,screen)
		if screen.is3D2D then
			popup_button:SetID("popup")
		else
			popup_button:SetID("exit")
		end
		popup_button:SetFrameType(0, 1)
		popup_button:SetSize(titlebar.button_size * 2, titlebar.button_size)
		popup_button:SetPos(right1, titlebar.button_posY)
		popup_button:SetIsToggle(false)

		local left_arrow, right_arrow

		local left_arrow = TardisScreenButton:new(titlebar,screen)
		left_arrow:SetID("left_arrow")
		left_arrow:SetFrameType(0, 1)
		left_arrow:SetSize(titlebar.button_size * 2, titlebar.button_size)
		left_arrow:SetPos(left2, titlebar.button_posY)
		left_arrow:SetIsToggle(false)
		left_arrow:SetText("<<<")
		screen.left_arrow = left_arrow

		local right_arrow = TardisScreenButton:new(titlebar,screen)
		right_arrow:SetID("right_arrow")
		right_arrow:SetFrameType(0, 1)
		right_arrow:SetSize(titlebar.button_size * 2, titlebar.button_size)
		right_arrow:SetPos(right2, titlebar.button_posY)
		right_arrow:SetIsToggle(false)
		right_arrow:SetText(">>>")
		screen.right_arrow = right_arrow
	else
		menubutton = vgui.Create("DButton", titlebar)
		menubutton:SetSize(titlebar:GetWide()*0.1,titlebar:GetTall())
		menubutton:SetPos(0, 0)

		backbutton = vgui.Create("DButton", titlebar)
		backbutton:SetSize(titlebar:GetWide() * 0.1, titlebar:GetTall())
		backbutton:SetPos(titlebar:GetWide() * 0.1, 0)

		popup_button = vgui.Create("DButton", titlebar)
		popup_button:SetSize(titlebar:GetWide() * 0.1, titlebar:GetTall())
		popup_button:SetPos(titlebar:GetWide() - popup_button:GetWide(), 0)
	end
	screen.titlebar=titlebar

	backbutton:SetText("Back")
	backbutton:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	backbutton:SetVisible(false)
	backbutton.DoClick = function()
		self:PopScreen(screen)
	end
	screen.backbutton=backbutton

	menubutton:SetText("Menu")
	menubutton:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	menubutton.DoClick = function(self)
		if IsValid(screen.curscreen) or not mmenu:IsVisible() then
			mmenu:SetVisible(not mmenu:IsVisible())
			if IsValid(screen.curscreen) then
				screen.curscreen:SetVisible(not mmenu:IsVisible())
			end
			if TARDIS:GetSetting("visgui_enabled") then
				screen.left_arrow:SetVisible(mmenu:IsVisible())
				screen.right_arrow:SetVisible(mmenu:IsVisible())
				if mmenu:IsVisible() then
					screen.RestoreHexLayout()
				end
			end
			pagename:SetText("")
			if mmenu:IsVisible() and backbutton:IsVisible() then
				backbutton:SetVisible(false)
			elseif (not mmenu:IsVisible()) and (#screen.backstack > 0) then
				backbutton:SetVisible(true)
			end
		end
	end
	screen.menubutton=menubutton

	popup_button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	if not screen.is3D2D then
		popup_button:SetText("Exit")
		popup_button.DoClick = function()
			TARDIS:RemoveHUDScreen()
		end
	else
		popup_button:SetText("Popup")
		popup_button.DoClick = function()
			self:PopToScreen(screen.pagename:GetText())
		end
	end

	screen.screens={}
	local ext=screen.ext
	local int=screen.int
	for k,v in pairs(screens) do
		if not ((v[1].intonly and (not IsValid(int)))
			or (v[1].menu==false and (not (IsValid(ext) and IsValid(int)))))
		then
			local frame = vgui.Create("DPanel",main)
			frame:SetVisible(false)
			frame:SetSize(main:GetSize())
			frame:SetPos(0,0)
			frame._name=k
			v[2](self,ext,int,frame,screen)
			table.insert(screen.screens,{k,frame,v[1]})
		end
	end
	table.SortByMember(screen.screens,1,true)

	self:LoadButtons(screen, mmenu, function(parent)
		local buttons={}
		for k,v in ipairs(screen.screens) do
			local options = v[3]
			local button = vgui.Create("DButton")
			button:SetText(v[1])
			button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
			button.DoClick = function()
				if options and options.popuponly and screen.is3D2D then
					self:PopToScreen(v[1])
				else
					self:SwitchScreen(screen, v[2])
				end
			end
			table.insert(buttons,button)
		end
		return buttons
	end, TARDIS:GetSetting("visgui_enabled"))

	return main
end

function TARDIS:LoadButtons(screen, frame, func, isvgui)
	if isvgui ~= nil and isvgui then
		local layout_rows
		if screen.is3D2D then
			if screen.visgui_rows == nil or TARDIS:GetSetting("visgui_override_numrows") then
				layout_rows = math.floor(TARDIS:GetSetting("visgui_screen_numrows"))
			else
				layout_rows = math.floor(screen.visgui_rows)
			end
		else
			layout_rows = math.floor(TARDIS:GetSetting("visgui_popup_numrows"))
		end

		local layout = HexagonalLayout:new(frame, layout_rows, 0.2)

		for k,v in ipairs(screen.screens) do
			local name = v[1]
			local options = v[3]
			local button = TardisScreenButton:new(frame,screen)
			button:SetID(options and options.id or name)
			button:SetFrameType(0, 1)
			button:SetIsToggle(false)
			button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
			button:SetText(name)
			button.DoClick = function()
				if screen.is3D2D and options and options.popuponly then
					self:PopToScreen(name)
				else
					self:SwitchScreen(screen, v[2])
				end
			end
			if options ~= nil then
				if options.text then
					button:SetText(options.text)
				end
				button:SetOrder(options.order)
			end
			layout:AddNewButton(button)
		end

		if IsValid(screen.ext) then
			for k,control in pairs(TARDIS:GetControls()) do
				local options = control.screen_button
				if options and options.mmenu and not (screen.is3D2D and options.popup_only) then
					local button = TardisScreenButton:new(frame, screen)
					if not control.id and not options.id then
						error("control id is required for TARDIS screen button")
					end
					if options.id then
						button:SetID(options.id)
					else
						button:SetID(control.id)
					end
					button:SetControl(control.id)

					if options.toggle ~= nil then
						button:SetIsToggle(options.toggle)
					end
					if options.frame_type ~= nil then
						button:SetFrameType(options.frame_type[1], options.frame_type[2])
					end
					if options.text ~= nil then
						button:SetText(options.text)
					end
					if options.pressed_state_data ~= nil then
						local src = options.pressed_state_from_interior and screen.int or screen.ext
						button:SetPressedStateData(src, options.pressed_state_data)
					end
					if options.order ~= nil then
						button:SetOrder(options.order)
					end

					layout:AddNewButton(button)
				end
			end
		end

		-- We keep these just in case someone needs custom buttons
		if IsValid(screen.ext) then
			screen.ext:CallHook("SetupMMenuButtons", screen, frame, layout)
		end
		if IsValid(screen.int) then
			screen.int:CallHook("SetupMMenuButtons", screen, frame, layout)
		end

		layout:DrawButtons()

		layout.scroll_size = math.max(1, layout:GetCols() - 1)

		local DoClickRight = function()
			if layout:CanMoveLeft()
				and not screen.left_arrow:IsPressed()
				and not screen.right_arrow:IsPressed()
			then
				layout:ScrollButtons(-layout.scroll_size)
			end
		end
		local DoClickLeft = function()
			if layout:CanMoveRight()
				and not screen.right_arrow:IsPressed()
				and not screen.left_arrow:IsPressed()
			then
				layout:ScrollButtons(layout.scroll_size)
			end
		end

		screen.RestoreHexLayout = function()
			screen.left_arrow.DoClick = DoClickLeft
			screen.right_arrow.DoClick = DoClickRight
		end
		screen.RestoreHexLayout()
	else
		local pages={}
		local page,spacew,spaceh
		local function newpage()
			page=vgui.Create("DPanel",frame)
			if #pages~=0 then
				page:SetVisible(false)
			end
			page:SetSize(frame:GetWide()-screen.gap2, frame:GetTall()-(frame:GetTall()*0.1)-screen.gap2)
			page:SetPos(screen.gap,screen.gap)
			page:SetBackgroundColor(Color(0,0,0,0))
			spacew=page:GetWide()-screen.gap
			spaceh=page:GetTall()-screen.gap
			table.insert(pages,page)
		end
		local function movebutton(button)
			local x,y=button:GetSize()
			local w=page:GetWide()-spacew
			local h=page:GetTall()-spaceh
			spacew=page:GetWide()-w-button:GetWide()-screen.gap
			if spacew < 0 then
				h=h+button:GetTall()+screen.gap
				spaceh=page:GetTall()-h
				spacew=page:GetWide()-screen.gap
				w=page:GetWide()-spacew
				spacew=page:GetWide()-w-button:GetWide()-screen.gap
			end
			if (spaceh-button:GetTall()-screen.gap) < 0 then
				newpage()
				button:SetParent(page)
				return movebutton(button)
			end
			return w,h
		end
		newpage()

		local buttons=func(frame)
		for k,v in ipairs(buttons) do
			v:SetParent(page)
			v:SetSize(page:GetWide()*0.318,page:GetTall()*0.295)
			v:SetPos(movebutton(v))
		end

		if #pages>1 then
			local curpage=1

			local label = vgui.Create("DLabel",frame)
			label:SetTextColor(Color(0,0,0))
			label:SetFont(TARDIS:GetScreenFont(screen, "PageName"))
			label.DoLayout = function()
				label:SizeToContents()
				label:SetPos(frame:GetWide()/2-label:GetWide()/2-screen.gap,frame:GetTall()-label:GetTall()-screen.gap)
			end
			label:SetText("Page "..curpage.." of "..#pages)
			label:DoLayout()

			local nxt

			local back=vgui.Create("DButton",frame)
			back:SetVisible(false)
			back:SetSize(frame:GetTall()*0.1-screen.gap,frame:GetTall()*0.1-screen.gap)
			back:SetPos(screen.gap,frame:GetTall()-back:GetTall()-screen.gap)
			back:SetText("<")
			back:SetFont(TARDIS:GetScreenFont(screen, "Default"))
			back.DoClick = function(self)
				if pages[curpage-1] then
					pages[curpage]:SetVisible(false)
					curpage=curpage-1
					pages[curpage]:SetVisible(true)
					label:SetText("Page "..curpage.." of "..#pages)
					if curpage==1 then
						back:SetVisible(false)
					end
					if not nxt:IsVisible() then
						nxt:SetVisible(true)
					end
				end
			end
			nxt=vgui.Create("DButton",frame)
			nxt:SetSize(frame:GetTall()*0.1-screen.gap,frame:GetTall()*0.1-screen.gap)
			nxt:SetPos(frame:GetWide()-nxt:GetWide()-screen.gap,frame:GetTall()-nxt:GetTall()-screen.gap)
			nxt:SetText(">")
			nxt:SetFont(TARDIS:GetScreenFont(screen, "Default"))
			nxt.DoClick = function(self)
				if pages[curpage+1] then
					pages[curpage]:SetVisible(false)
					curpage=curpage+1
					pages[curpage]:SetVisible(true)
					label:SetText("Page "..curpage.." of "..#pages)
					if curpage==#pages then
						nxt:SetVisible(false)
					end
					if not back:IsVisible() then
						back:SetVisible(true)
					end
				end
			end
		end
	end
end

function TARDIS:LoadScreen(id, options)
	local screen = vgui.Create("DPanel")
	screen.id=id
	screen.is3D2D=true
	local maxWidth = math.min(ScrW(), 1000)
	local maxHeight = math.min(ScrH(), 1000)
	local idealWidth = maxHeight * (options.width / options.height)
	local newWidth = math.min(idealWidth, maxWidth)
	local newHeight = maxHeight / (idealWidth / newWidth)
	screen.width=newWidth
	screen.height=newHeight
	screen.resscale = (options.width / screen.width) * 1.7
	screen.res=screen.width / options.width
	screen.ext=options.ext
	screen.int=options.int
	screen.visgui_rows=options.visgui_rows
	screen.power_off_black = options.power_off_black
	screen.crosshair=6 * screen.res
	screen.gap=10
	screen.gap2=screen.gap * 2
	screen:SetSkin("TARDIS")
	screen:SetPos(0, 0)
	screen:SetSize(screen.width, screen.height)
	screen:SetPaintedManually(true) -- change to false to debug screen sizes in 2D
	screen:SetDrawBackground(true)
	screen:SetBackgroundColor(Color(0,0,0,0))

	local main=self:LoadScreenUI(screen)
	local frame=screen.frame
	frame:SetVisible(true)
	frame:SetPos(screen.gap,screen.gap)
	frame:SetAlpha(230)

	screen.Think = function(self)
		local shouldDraw = not (self.int:CallHook("ShouldNotDrawScreen", self.id) or false)
		local blackScreen = self.int:CallHook("ShouldDrawBlackScreen", self.id) or false
		local scr_on = self.int:GetData("screens_on", false)
		local pwr_on = self.ext:GetData("power-state", false)
		if self.draw ~= shouldDraw or self.black ~= blackScreen then
			self.frame:SetVisible(shouldDraw and not blackScreen)
			if shouldDraw or (blackScreen and self.power_off_black) then
				self:SetBackgroundColor(Color(0,0,0,255))
			else
				self:SetBackgroundColor(Color(0,0,0,0))
			end
			self.draw = shouldDraw
			self.black = blackScreen
		end
	end

	return screen
end
