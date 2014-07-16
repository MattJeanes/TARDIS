ENT:AddHook("Draw", "lights", function(self)
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
	end
	dlight.DieTime = CurTime() + 1
end)