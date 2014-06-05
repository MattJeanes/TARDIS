include('shared.lua')

function ENT:Draw()
	cam.Start3D(EyePos(),EyeAngles(),LocalPlayer():GetFOV())
	//render.SuppressEngineLighting( true )
	//render.ResetModelLighting( 1,1,1 )
	for i=0,5 do
		render.SetModelLighting( i, 1,1,1 )
	end
	//render.SetColorModulation( 1,1,1 )
	//render.SetBlend( 1 )
	self:DrawModel()	
	if WireLib then
		Wire_Render(self)
	end
	//render.SuppressEngineLighting( false )
	cam.End3D()
	
end

function ENT:Initialize()
	self:CallHook("Initialize")
end

function ENT:Think()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local size=1024
		local c=Color(255,50,0)
		dlight.Pos = self:LocalToWorld(Vector(0,0,0))
		dlight.r = c.r
		dlight.g = c.g
		dlight.b = c.b
		dlight.Brightness = 8
		dlight.Decay = size * 5
		dlight.Size = size
		dlight.DieTime = CurTime() + 1
	end
end