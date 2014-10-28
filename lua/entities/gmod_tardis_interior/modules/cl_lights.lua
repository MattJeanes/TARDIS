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

ENT:AddHook("Initialize", "spritetest", function(self)
	self.pixvis=util.GetPixelVisibleHandle()
end)

ENT:AddHook("PostDrawTranslucentRenderables", "spritetest", function(self)
	if self:CallHook("ShouldDraw") then
		local SPos = Vector(11,425,205)
		Pos = self:LocalToWorld(SPos)
		local Vis = util.PixelVisible(Pos, 3, self.pixvis)*255
		if Vis > 0 then
			local Mat = Material("sprites/light_ignorez")
			render.SetMaterial(Mat)

			local Size = 10
			render.DrawSprite(Pos, Size, Size, Color(255,153,0, Vis))
		end
	end
end)