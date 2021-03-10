-- Adds screens

if SERVER then
	ENT:LoadFolder("modules/screens")
	return
end

ENT.screenres=1.7
ENT.screenx=0
ENT.screeny=0
ENT.screengap=0
ENT.screengap2=0

local screens={}
function ENT:AddScreen(name,func)
	screens[name]=func
end
ENT:LoadFolder("modules/screens")

function ENT:GetScreens()
	return screens
end

ENT:AddHook("Initialize", "screens", function(self)
	local screens=self.metadata.Interior.Screens
	if screens then
		self.screens3D={}
		for k,v in pairs(screens) do
			self.screens3D[k]=TARDIS:LoadScreen(k,{width=v.width,height=v.height,ext=self.exterior,int=self})
			self.screens3D[k].pos3D=v.pos
			self.screens3D[k].ang3D=v.ang
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

-- Thanks world-portals
function ENT:ShouldRenderScreen(screen)
	local camOrigin = GetViewEntity():GetPos()
	local pos = self:LocalToWorld(screen.pos3D)
	local ang = self:LocalToWorldAngles(screen.ang3D)
	local distance = camOrigin:Distance(pos)
	local disappearDist = self.metadata.Interior.ScreenDistance
	
	if not (disappearDist <= 0) and distance > disappearDist then return false end
	
	--don't render if the view is behind the portal
	local behind = TARDIS:IsBehind( camOrigin, pos, ang:Up() )
	if behind then return false end
	
	return true, pos, ang
end

ENT:AddHook("PostDrawTranslucentRenderables", "screens", function(self)
	if self.screens3D then
		for k,v in pairs(self.screens3D) do
			local should,pos,ang = self:ShouldRenderScreen(v)
			if should then
				local col=Color(0,0,0,255)
				vgui.Start3D2D(pos,ang,0.0624*(1/TARDIS.screenres))
					draw.RoundedBox(0,0,0,v.width,v.height,col)
					v:Paint3D2D()
				vgui.End3D2D()
			end
		end
	end
end)

function ENT:SetScreensOn(on)
	if on then
		local screens=self.metadata.Interior.Screens
		if screens then
			for k,v in pairs(screens) do
				self.screens3D[k].frame:SetVisible(on)
			end
		end
	end
	self:SetData("screens_on", on, true)
	return true
end

function ENT:ToggleScreens()
	self:SetScreensOn(not self:GetData("screens_on", false))
	return true
end
