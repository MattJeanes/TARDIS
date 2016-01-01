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

ENT:AddHook("PostDrawTranslucentRenderables", "screens", function(self)
	if self.screens3D then
		for k,v in pairs(self.screens3D) do
			local col=HSVToColor(180+math.sin(CurTime()*0.1)*180,0.5,1)
			vgui.Start3D2D(self:LocalToWorld(v.pos3D),self:LocalToWorldAngles(v.ang3D),0.0624*(1/TARDIS.screenres))
				draw.RoundedBox(0,0,0,v.width,v.height,col)
				v:Paint3D2D()
			vgui.End3D2D()
		end
	end
end)