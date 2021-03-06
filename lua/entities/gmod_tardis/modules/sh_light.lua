-- Exterior light

if SERVER then
	function ENT:FlashLight(time)
		self:SendMessage("flash-light",function()
			net.WriteFloat(time)
		end)
	end
else
	TARDIS:AddSetting({
		id="extlight-color",
		name="External Light Color",
		section="Misc",
		desc="The color of the exterior light, uses interior default if unchanged",
		value=false,
		type="color",
		option=true,
		networked=true
	})
	
	function ENT:FlashLight(time)
		self:SetData("flashuntil",CurTime()+time)
	end
	
	ENT:AddHook("ShouldTurnOnLight","light",function(self)
		local flashuntil=self:GetData("flashuntil")
		if flashuntil then
			if CurTime()<flashuntil then
				return true
			else
				self:SetData("flashuntil",nil)
			end
		end
	end)
	
	ENT:OnMessage("flash-light",function(self)
		self:FlashLight(net.ReadFloat())
	end)

	ENT:AddHook("Initialize", "light", function(self)
		self.lightpixvis=util.GetPixelVisibleHandle()
	end)

	local mat=Material("models/drmatt/tardis/exterior/light")
	local size=64

	ENT:AddHook("Draw", "light", function(self)
		local isCloaked = self:GetData("cloaked")
		local light = self.metadata.Exterior.Light
		if not light.enabled then return end
		
		local shouldon=self:CallHook("ShouldTurnOnLight")
		local shouldoff=self:CallHook("ShouldTurnOffLight")
		
		if shouldon and (not shouldoff) and not isCloaked then
			if self.lightpixvis and (not wp.drawing) and (halo.RenderedEntity()~=self) then
				local pos=self:LocalToWorld(light.pos)
				local pulse=(math.sin(CurTime()*8)+1)*(255/4)+(255/2)-50
				render.SetMaterial(mat)
				local fallback=false
				for k,v in pairs(wp.portals) do -- not ideal but does the job
					if wp.shouldrender(v) and v:GetShouldDrawNextFrame() then
						fallback=true
						break
					end
				end
				local col = TARDIS:GetSetting("extlight-color",nil,self:GetCreator())
				if not col then
					col = light.color
				end
				if fallback then
					render.DrawSprite(pos, size, size, Color(col.r,col.g,col.b,pulse))
				else
					local vis=util.PixelVisible(pos, 3, self.lightpixvis)*255
					if vis>0 then
						render.DrawSprite(pos, size, size, Color(col.r,col.g,col.b,math.min(vis,pulse)))
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