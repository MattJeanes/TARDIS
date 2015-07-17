-- Adds screens

if SERVER then -- Send screen files to client then exit
	ENT:LoadFolder("modules/screens", true)
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
	self.exterior:UpdateScreenInfo(self.exterior,self.interior.ID)
	local screens=self.interior.Screens
	if screens then
		self.screens3D={}
		for k,v in pairs(screens) do
			self.screens3D[k]=self.exterior:LoadScreen(k)
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