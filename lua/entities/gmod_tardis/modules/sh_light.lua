-- Exterior light

if CLIENT then
	ENT:AddHook("Initialize", "light", function(self)
		self.lightpixvis=util.GetPixelVisibleHandle()
	end)
	local mat=Material("models/drmatt/tardis/exterior/light")
	local size=64
	ENT:AddHook("Draw", "light", function(self)
		local shouldon=self:CallHook("ShouldTurnOnLight")
		local shouldoff=self:CallHook("ShouldTurnOffLight")
		
		if shouldon and (not shouldoff) then
			if self.lightpixvis and (not wp.drawing) and (halo.RenderedEntity()~=self) then
				local pos=self:LocalToWorld(Vector(0,0,122))
				local pulse=(math.sin(CurTime()*8)+1)*(255/4)+(255/2)-50
				render.SetMaterial(mat)
				local fallback=false
				for k,v in pairs(wp.portals) do -- not ideal but does the job
					if wp.shouldrender(v) and v:GetShouldDrawNextFrame() then
						fallback=true
						break
					end
				end
				if fallback then
					render.DrawSprite(pos, size, size, Color(255,255,255,pulse))
				else
					local vis=util.PixelVisible(pos, 3, self.lightpixvis)*255
					if vis>0 then
						render.DrawSprite(pos, size, size, Color(255,255,255,math.min(vis,pulse)))
					end
				end
			end
			
			--[[ disabled due to flickering todo: investigate why this is
			local dlight = DynamicLight( self:EntIndex() )
			if ( dlight ) then
				local size=400
				local v=Vector(255,255,255)
				local c=Color(v.x,v.y,v.z)
				dlight.Pos = self:GetPos() + self:GetUp() * 135
				dlight.r = c.r
				dlight.g = c.g
				dlight.b = c.b
				dlight.Brightness = 5
				dlight.Decay = size * 5
				dlight.Size = size
				dlight.DieTime = CurTime() + 1
			end
			--]]
		end
	end)
end