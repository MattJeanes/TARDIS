-- Adds screens

if SERVER then -- Send screen files to client then exit
	ENT:LoadFolder("modules/screens", true)
	return
end

surface.CreateFont("TARDIS-Main", {
	font="Roboto",
	size=50
})

surface.CreateFont("TARDIS-Large", {
	font="Roboto",
	size=40
})

local screens={}
function TARDIS_AddScreen(name,func)
	screens[name]=func
end
ENT:LoadFolder("modules/screens")

function ENT:SwitchScreen(screen,name)
	local newscreen=screen.screens[name]
	if IsValid(newscreen) then
		if IsValid(screen.curscreen) then
			screen.curscreen:SetVisible(false)
		end
		newscreen:SetVisible(true)
		screen.curscreen=newscreen
		if IsValid(screen.mmenu) then
			screen.mmenu:SetVisible(false)
		end
	end
end

ENT:AddHook("Initialize", "screens", function(self)
	for i=1,2 do
		local screen = vgui.Create("DPanel")
		screen:SetPos( 0, 0 )
		screen:SetSize( 485,250 )
		screen:SetPaintedManually(true)
		screen:SetDrawBackground(false)
		
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
		
		local main = vgui.Create("DPanel",screen)
		main:SetVisible(false)
		main:SetSize(screen:GetWide()-10, screen:GetTall()-10)
		main:SetPos(5,5)
		main:SetAlpha(230)
		
		screen.screens={}
		for k,v in pairs(screens) do
			screen.screens[k]=v(self,main)
			if not IsValid(screen.curscreen) then
				self:SwitchScreen(screen,k)
			end
		end
		
		local mmenu = vgui.Create("DPanel",main)
		mmenu:SetVisible(false)
		mmenu:SetSize(main:GetSize())
		mmenu:SetPos(0,0)
		screen.mmenu=mmenu
		
		do -- local scope
			local i=0
			for k,v in pairs(screen.screens) do
				local menubutton=vgui.Create("DButton",mmenu)
				menubutton:SetText(k)
				menubutton:SizeToContents()
				menubutton:SetSize(menubutton:GetWide()+15,20)
				menubutton:SetPos(0,30+(i*25))
				menubutton.DoClick = function()
					self:SwitchScreen(screen,k)
				end
				i=i+1
			end
		end
		
		local menubutton=vgui.Create("DButton",screen)
		menubutton:SetVisible(false)
		menubutton:SetSize(50,20)
		menubutton:SetPos(main:GetPos())
		menubutton:SetText("Menu")
		menubutton.DoClick = function(self)
			mmenu:SetVisible(not mmenu:IsVisible())
		end
		
		local close
		
		local showui = vgui.Create("DButton",screen)
		showui:SetText("Show UI")
		showui:SetSize(200,30)
		showui:SetPos((screen:GetWide()*0.5)-(showui:GetWide()*0.5),(screen:GetTall()*0.8)-(showui:GetTall()*0.5))
		showui.DoClick = function(self)
			label:SetVisible(false)
			main:SetVisible(true)
			menubutton:SetVisible(true)
			self:SetVisible(false)
			close:SetVisible(true)
		end
		
		close = vgui.Create("DButton",screen)
		close:SetVisible(false)
		close:SetText("X")
		close:SetSize(30,20)
		local x,y=main:GetPos()
		close:SetPos(x+main:GetWide()-close:GetWide(),y)
		close.DoClick = function(self)
			label:SetVisible(true)
			main:SetVisible(false)
			menubutton:SetVisible(false)
			showui:SetVisible(true)
			self:SetVisible(false)
		end
		
		if i==1 then
			self.screen1=screen
		elseif i==2 then
			self.screen2=screen
		end
	end
end)

ENT:AddHook("OnRemove", "screens", function(self)
	self.screen1:Remove()
	self.screen2:Remove()
end)
	
ENT:AddHook("Draw", "screens", function(self)
	local col=HSVToColor(180+math.sin(CurTime()*0.1)*180,0.5,1)
	vgui.Start3D2D(self:LocalToWorld(Vector(44.35,-10.58,162.6)),self:LocalToWorldAngles(Angle(0,90,90)),0.06)
		draw.RoundedBox(0,0,0,485,250,col)
		self.screen1:Paint3D2D()
	vgui.End3D2D()
	
	vgui.Start3D2D(self:LocalToWorld(Vector(-45.15,17.9,163.55)),self:LocalToWorldAngles(Angle(0,-90,90)),0.06)
		draw.RoundedBox(0,0,0,485,250,col)
		self.screen2:Paint3D2D()
	vgui.End3D2D()
end)