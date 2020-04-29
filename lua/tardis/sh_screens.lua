-- Adds screens

function TARDIS:HUDScreenOpen(ply)
	if SERVER then
		return ply.TARDISHUDScreen
	else
		return self.HUDScreenActive
	end
end

if SERVER then
	TARDIS:LoadFolder("screens")
	util.AddNetworkString("TARDIS-HUDScreen")
	net.Receive("TARDIS-HUDScreen",function(len,ply)
		ply.TARDISHUDScreen=net.ReadBool()
	end)
	return
end

TARDIS.screenres=1.7

surface.CreateFont("TARDIS-Default", {
	font="Tahoma",
	size=13*TARDIS.screenres
})

surface.CreateFont("TARDIS-Main", {
	font="Roboto",
	size=50*TARDIS.screenres
})

surface.CreateFont("TARDIS-Large", {
	font="Roboto",
	size=40*TARDIS.screenres
})

surface.CreateFont("TARDIS-Med", {
	font="Roboto",
	size=24*TARDIS.screenres
})

surface.CreateFont("TARDIS-PageName", {
	font="Roboto",
	size=20*TARDIS.screenres
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
		end
	end
end

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
	screen.width=485*self.screenres
	screen.height=250*self.screenres
	screen.res=self.screenres
	screen.crosshair=6*screen.res
	screen.gap=5*screen.res
	screen.gap2=screen.gap*2
	screen.ext=TARDIS:GetExteriorEnt()
	screen.int=TARDIS:GetInteriorEnt()
	screen:SetSize(screen.width,screen.height)
	screen:SetPos( 2,25 )
	self:LoadScreenUI(screen)
	local x,y=screen:GetSize()
	screen:SetSize(x-screen.gap2,y-screen.gap2)
	local x,y=screen:GetSize()
	frame:SetSize(x+4,y+27)
	frame:Center()
	self.screenpop=screen
	
	local titlebar=screen.titlebar
	close = vgui.Create("DButton",titlebar)
	close:SetText("X")
	close:SetFont("TARDIS-Default")
	close:SetSize(titlebar:GetWide()*0.08,titlebar:GetTall())
	close:SetPos(titlebar:GetWide()-close:GetWide())
	close.DoClick = function(self)
		TARDIS:RemoveHUDScreen()
	end
	
	if timer.Exists("TARDIS-HUDScreen") then
		timer.Remove("TARDIS-HUDScreen")
	end
	self.HUDScreenActive=true
	net.Start("TARDIS-HUDScreen")
		net.WriteBool(true)
	net.SendToServer()
end
concommand.Add("tardis_toggleui", function()
	TARDIS:HUDScreen()
end)

function TARDIS:LoadScreenUI(screen)
	local frame = vgui.Create("DPanel", screen)
	frame:SetSize(screen:GetWide()-screen.gap2,screen:GetTall()-screen.gap2)
	screen.frame=frame
	
	screen.backstack={}
	
	local titlebar = vgui.Create("DPanel",frame)
	titlebar:SetSize(frame:GetWide(), frame:GetTall()*0.1)
	titlebar:SetPos(0,0)
	titlebar:SetBackgroundColor(Color(220,220,220))
	screen.titlebar=titlebar
	
	local pagename = vgui.Create("DLabel",titlebar)
	pagename:SetTextColor(Color(0,0,0))
	pagename:SetFont("TARDIS-PageName")
	pagename.DoLayout = function(self)
		pagename:SizeToContents()
		pagename:SetPos((titlebar:GetWide()*0.5)-(pagename:GetWide()*0.5),(titlebar:GetTall()*0.5)-(pagename:GetTall()*0.5))
	end
	pagename:SetText("")
	pagename:DoLayout()
	screen.pagename=pagename
	
	local backbutton = vgui.Create("DButton",titlebar)
	backbutton:SetVisible(false)
	backbutton:SetText("Back")
	backbutton:SetFont("TARDIS-Default")
	backbutton:SetSize(titlebar:GetWide()*0.1, titlebar:GetTall())
	backbutton:SetPos(titlebar:GetWide()*0.1+screen.gap,0)
	backbutton.DoClick = function()
		self:PopScreen(screen)
	end
	screen.backbutton=backbutton
	
	local main = vgui.Create("DPanel",frame)
	main:SetSize(frame:GetWide(),frame:GetTall()-titlebar:GetTall())
	main:SetPos(0,titlebar:GetTall())
	screen.main=main
	
	screen.screens={}
	local ext=screen.ext
	local int=screen.int
	for k,v in pairs(screens) do
		if (v[1].intonly and (not IsValid(int))) or (v[1].menu==false and (not (IsValid(ext) and IsValid(int)))) then
			continue
		end
		local frame = vgui.Create("DPanel",main)
		frame:SetVisible(false)
		frame:SetSize(main:GetSize())
		frame:SetPos(0,0)
		frame._name=k
		v[2](self,ext,int,frame,screen)
		table.insert(screen.screens,{k,frame})
	end
	table.SortByMember(screen.screens,1,true)
	
	local mmenu = vgui.Create("DPanel",main)
	mmenu:SetSize(main:GetSize())
	mmenu:SetPos(0,0)
	screen.mmenu=mmenu
	
	self:LoadButtons(screen,mmenu,function(frame)
		local buttons={}
		for k,v in ipairs(screen.screens) do
			local button=vgui.Create("DButton")
			button:SetText(v[1])
			button:SetFont("TARDIS-Default")
			button.DoClick = function()
				self:SwitchScreen(screen,v[2])
			end
			table.insert(buttons,button)
		end
		return buttons
	end)
	
	local menubutton=vgui.Create("DButton",titlebar)
	menubutton:SetSize(titlebar:GetWide()*0.1,titlebar:GetTall())
	menubutton:SetPos(0,0)
	menubutton:SetText("Menu")
	menubutton:SetFont("TARDIS-Default")
	menubutton.DoClick = function(self)
		if not ((not IsValid(screen.curscreen)) and mmenu:IsVisible()) then
			mmenu:SetVisible(not mmenu:IsVisible())
			if mmenu:IsVisible() and backbutton:IsVisible() then
				backbutton:SetVisible(false)
			elseif (not mmenu:IsVisible()) and (#screen.backstack>0) then
				backbutton:SetVisible(true)
			end
		end
	end
	screen.menubutton=menubutton
	
	return main
end

function TARDIS:LoadButtons(screen,frame,func)
	local pages={}
	local page,spacew,spaceh
	local function newpage()
		page=vgui.Create("DPanel",frame)
		if #pages~=0 then
			page:SetVisible(false)
		end
		page:SetSize(frame:GetWide()-screen.gap2, frame:GetTall()-(frame:GetTall()*0.1)-screen.gap2)
		page:SetPos(screen.gap,screen.gap)
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
		label:SetFont("TARDIS-PageName")
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
		back:SetFont("TARDIS-Default")
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
		nxt:SetFont("TARDIS-Default")
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

function TARDIS:LoadScreen(id,options)
	local screen = vgui.Create("DPanel")
	screen.id=id
	screen.is3D2D=true
	screen.width=options.width*self.screenres
	screen.height=options.height*self.screenres
	screen.ext=options.ext
	screen.int=options.int
	screen.res=self.screenres
	screen.crosshair=6*screen.res
	screen.gap=5*screen.res
	screen.gap2=screen.gap*2
	screen:SetSkin("TARDIS")
	screen:SetPos(0,0)
	screen:SetSize(screen.width,screen.height)
	screen:SetPaintedManually(true)
	screen:SetDrawBackground(false)
	
	local main=self:LoadScreenUI(screen)
	local frame=screen.frame
	frame:SetVisible(false)
	frame:SetPos(screen.gap,screen.gap)
	frame:SetAlpha(230)
	local titlebar=screen.titlebar
	
	local label = vgui.Create("DLabel",screen)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Main")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((screen:GetWide()*0.5)-(label:GetWide()*0.5),(screen:GetTall()*0.4)-(label:GetTall()*0.5))
	end
	label:SetText([[ TARDIS Rewrite
	Work In Progress]])
	label:DoLayout()
	
	local close,popup
	
	local showui = vgui.Create("DButton",screen)
	showui:SetText("Open UI")
	showui:SetFont("TARDIS-Default")
	showui:SetSize(screen:GetWide()*0.2,screen:GetTall()*0.1)
	showui:SetPos((screen:GetWide()*0.5)-(showui:GetWide()*0.5),(screen:GetTall()*0.8)-(showui:GetTall()*0.5))
	showui.DoClick = function(self)
		label:SetVisible(false)
		self:SetVisible(false)
		frame:SetVisible(true)
	end
	
	close = vgui.Create("DButton",titlebar)
	close:SetText("X")
	close:SetFont("TARDIS-Default")
	close:SetSize(titlebar:GetWide()*0.08,titlebar:GetTall())
	close:SetPos(titlebar:GetWide()-close:GetWide())
	close.DoClick = function(self)
		label:SetVisible(true)
		showui:SetVisible(true)
		frame:SetVisible(false)
	end
	
	popup = vgui.Create("DButton",titlebar)
	popup:SetText("Popup")
	popup:SetFont("TARDIS-Default")
	popup:SetSize(titlebar:GetWide()*0.1,titlebar:GetTall())
	popup:SetPos(titlebar:GetWide()-popup:GetWide()-close:GetWide()-screen.gap,0)
	popup.DoClick = function()
		close:DoClick()
		self:HUDScreen()
	end
	
	return screen
end