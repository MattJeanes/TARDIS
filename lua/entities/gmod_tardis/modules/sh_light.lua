-- Exterior light

if SERVER then
	function ENT:SetLight(on)
		if (not on) and self:CallHook("CanTurnOffLight")==false then return end
		self:SetData("light", on, true)
	end
else
	ENT:AddHook("Initialize", "light", function(self)
		self.lightpixvis=util.GetPixelVisibleHandle()
	end)
	local mat=Material("models/drmatt/tardis/exterior/light")
	local size=64
	ENT:AddHook("Draw", "light", function(self)
		if self.lightpixvis and (not wp.drawing) and self:GetData("light") then
			local pos=self:LocalToWorld(Vector(0,0,122))
			local pulse=(math.sin(CurTime()*8)+1)*(255/4)+(255/2)-50
			render.SetMaterial(mat)
			if IsValid(self.interior) and self.interior.portals and wp.shouldrender(self.interior.portals[1]) then
				render.DrawSprite(pos, size, size, Color(255,255,255,pulse))
			else
				local vis=util.PixelVisible(pos, 3, self.lightpixvis)*255
				if vis>0 then
					render.DrawSprite(pos, size, size, Color(255,255,255,math.min(vis,pulse)))
				end
			end
		end
	end)
end