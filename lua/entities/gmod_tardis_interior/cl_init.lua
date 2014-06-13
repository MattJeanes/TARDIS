include('shared.lua')

function ENT:Draw()
	self:DrawModel()	
	if WireLib then
		Wire_Render(self)
	end
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
	
	self:CallHook("Think")
end
