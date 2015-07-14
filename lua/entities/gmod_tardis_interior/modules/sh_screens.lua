-- Adds screens

if SERVER then -- Send screen files to client then exit
	ENT:LoadFolder("modules/screens", true)
	return
end

ENT.screenres=1.7

surface.CreateFont("TARDIS-Default", {
	font="Tahoma",
	size=13*ENT.screenres
})

surface.CreateFont("TARDIS-Main", {
	font="Roboto",
	size=50*ENT.screenres
})

surface.CreateFont("TARDIS-Large", {
	font="Roboto",
	size=40*ENT.screenres
})

surface.CreateFont("TARDIS-Med", {
	font="Roboto",
	size=24*ENT.screenres
})

surface.CreateFont("TARDIS-PageName", {
	font="Roboto",
	size=20*ENT.screenres
})

local function update(self,id)
	local int=self:GetInterior(id)
	if int then
		self.screenx=(int.ScreenX or 485)*self.screenres
		self.screeny=(int.ScreenY or 250)*self.screenres
		self.screengap=5*self.screenres
		self.screengap2=self.screengap*2
	end
end
update(ENT,TARDIS:GetSetting("interior","default",true))

local screens={}
function ENT:AddScreen(name,func)
	screens[name]=func
end
ENT:LoadFolder("modules/screens")

function ENT:ScreenActive(name)
	local t={}
	if self.screens3D then
		for k,v in pairs(self.screens3D) do
			if IsValid(v) and IsValid(v.curscreen) and v.frame:IsVisible() and v.curscreen._name==name then
				table.insert(t,v)
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

function ENT:SwitchScreen(screen,newscreen)
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

function ENT:PopScreen(screen,all)
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

function ENT:PushScreen(name,screen,f,f2)
	local titlebar=screen.titlebar
	local pagename=screen.pagename
	local oldname=pagename:GetText()
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

function ENT:HUDScreen()
	local frame=vgui.Create("DFrame")
	frame:SetSkin("TARDIS")
	frame:SetTitle("TARDIS Interface")
	frame:SetDraggable(true)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	
	local screen = vgui.Create("DPanel",frame)
	screen.id="pop"
	screen:SetSize( self.screenx,self.screeny )
	screen:SetPos( 2,25 )
	self:LoadScreenUI(screen)
	local x,y=screen:GetSize()
	screen:SetSize(x-self.screengap2,y-self.screengap2)
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
		frame:Remove()
	end
end

function ENT:LoadScreenUI(screen)
	local frame = vgui.Create("DPanel", screen)
	frame:SetSize(screen:GetWide()-self.screengap2,screen:GetTall()-self.screengap2)
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
	backbutton:SetPos(titlebar:GetWide()*0.1+self.screengap,0)
	backbutton.DoClick = function()
		self:PopScreen(screen)
	end
	screen.backbutton=backbutton
	
	local main = vgui.Create("DPanel",frame)
	main:SetSize(frame:GetWide(),frame:GetTall()-titlebar:GetTall())
	main:SetPos(0,titlebar:GetTall())
	screen.main=main
	
	screen.screens={}
	for k,v in pairs(screens) do
		local frame = vgui.Create("DPanel",main)
		frame:SetVisible(false)
		frame:SetSize(main:GetSize())
		frame:SetPos(0,0)
		frame._name=k
		v(self,frame,screen)
		table.insert(screen.screens,{k,frame})
	end
	table.SortByMember(screen.screens,1,true)
	
	local mmenu = vgui.Create("DPanel",main)
	mmenu:SetSize(main:GetSize())
	mmenu:SetPos(0,0)
	screen.mmenu=mmenu
	
	self:LoadButtons(mmenu,function(frame)
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

function ENT:LoadButtons(frame,func)
	local pages={}
	local page,spacew,spaceh
	local function newpage()
		page=vgui.Create("DPanel",frame)
		if #pages~=0 then
			page:SetVisible(false)
		end
		page:SetSize(frame:GetWide()-self.screengap2, frame:GetTall()-(frame:GetTall()*0.1)-self.screengap2)
		page:SetPos(self.screengap,self.screengap)
		spacew=page:GetWide()-self.screengap
		spaceh=page:GetTall()-self.screengap
		table.insert(pages,page)
	end
	local function movebutton(button)
		local x,y=button:GetSize()
		local w=page:GetWide()-spacew
		local h=page:GetTall()-spaceh
		spacew=page:GetWide()-w-button:GetWide()-self.screengap
		if spacew < 0 then
			h=h+button:GetTall()+self.screengap
			spaceh=page:GetTall()-h
			spacew=page:GetWide()-self.screengap
			w=page:GetWide()-spacew
			spacew=page:GetWide()-w-button:GetWide()-self.screengap
		end
		if (spaceh-button:GetTall()-self.screengap) < 0 then
			newpage()
			vgui.SetParent3D2D(button,page)
			return movebutton(button)
		end
		return w,h
	end
	newpage()
	
	local buttons=func(frame)
	for k,v in ipairs(buttons) do
		vgui.SetParent3D2D(v,page)
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
			label:SetPos(frame:GetWide()/2-label:GetWide()/2-self.screengap,frame:GetTall()-label:GetTall()-self.screengap)
		end
		label:SetText("Page "..curpage.." of "..#pages)
		label:DoLayout()
		
		local nxt
		local back=vgui.Create("DButton",frame)
		back:SetVisible(false)
		back:SetSize(frame:GetTall()*0.1-self.screengap,frame:GetTall()*0.1-self.screengap)
		back:SetPos(self.screengap,frame:GetTall()-back:GetTall()-self.screengap)
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
		nxt:SetSize(frame:GetTall()*0.1-self.screengap,frame:GetTall()*0.1-self.screengap)
		nxt:SetPos(frame:GetWide()-nxt:GetWide()-self.screengap,frame:GetTall()-nxt:GetTall()-self.screengap)
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

function ENT:LoadScreen(id)
	local screen = vgui.Create("DPanel")
	screen.id=id
	screen.is3D2D=true
	screen.crosshair=6*self.screenres
	screen:SetSkin("TARDIS")
	screen:SetPos(0,0)
	screen:SetSize(self.screenx,self.screeny)
	screen:SetPaintedManually(true)
	screen:SetDrawBackground(false)
	
	local main=self:LoadScreenUI(screen)
	local frame=screen.frame
	frame:SetVisible(false)
	frame:SetPos(self.screengap,self.screengap)
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
	popup:SetPos(titlebar:GetWide()-popup:GetWide()-close:GetWide()-self.screengap,0)
	popup.DoClick = function()
		close:DoClick()
		self:HUDScreen()
	end
	
	return screen
end

ENT:AddHook("Initialize", "screens", function(self)
	update(self,self.interior.ID)
	local screens=self.interior.Screens
	if screens then
		self.screens3D={}
		for k,v in pairs(screens) do
			self.screens3D[k]=self:LoadScreen(k)
			self.screens3D[k].Pos3D=v.pos
			self.screens3D[k].Ang3D=v.ang
		end
	end
end)

ENT:AddHook("OnRemove", "screens", function(self)
	if self.screens3D then
		for k,v in pairs(self.screens3D) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end)
	
ENT:AddHook("Draw", "screens", function(self)
	if self.screens3D then
		for k,v in pairs(self.screens3D) do
			local col=HSVToColor(180+math.sin(CurTime()*0.1)*180,0.5,1)
			vgui.Start3D2D(self:LocalToWorld(v.Pos3D),self:LocalToWorldAngles(v.Ang3D),0.0624*(1/self.screenres))
				draw.RoundedBox(0,0,0,self.screenx,self.screeny,col)
				v:Paint3D2D()
			vgui.End3D2D()
		end
	end
end)