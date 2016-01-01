-- Lights

--[[
ENT:AddHook("PreDraw", "lights", function(self)
	render.SuppressEngineLighting(true)
	render.SetLocalModelLights({
		{
			pos=self:LocalToWorld(Vector(0,0,200)),
			color=Vector(0,3,8)
		},
		{
			pos=self:LocalToWorld(Vector(0,0,100)),
			color=Vector(0,5,5)
		}
	})
end)
]]--

ENT:AddHook("Draw", "lights", function(self)
	--render.SuppressEngineLighting(false)
	local data=self.metadata.Interior.Light
	if data then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local size=1024
			local c=data.color
			dlight.Pos = self:LocalToWorld(data.pos)
			dlight.r = c.r
			dlight.g = c.g
			dlight.b = c.b
			dlight.Brightness = data.brightness
			dlight.Decay = size * 5
			dlight.Size = size
			dlight.DieTime = CurTime() + 1
		end
	end
end)

function ENT:AddRoundThing(pos)
	self.roundthings[pos]=util.GetPixelVisibleHandle()
end


ENT:AddHook("Initialize", "spritetest", function(self)
	if self.metadata.Interior.RoundThings then
		self.roundthingmat=Material("sprites/light_ignorez")
		self.roundthings={}
		for k,v in pairs(self.metadata.Interior.RoundThings) do
			self:AddRoundThing(v)
		end
	end
end)

local size=32
ENT:AddHook("Draw", "spritetest", function(self)
	if self.roundthings then
		for k,v in pairs(self.roundthings) do
			local pos = self:LocalToWorld(k)
			local vis = util.PixelVisible(pos, 3, v)*255
			if vis > 0 then
				render.SetMaterial(self.roundthingmat)
				render.DrawSprite(pos, size, size, Color(255,153,0, vis))
			end
		end
	end
end)