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
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local size=1024
		local c=Color(0,100,255)
		dlight.Pos = self:LocalToWorld(Vector(0,0,0))
		dlight.r = c.r
		dlight.g = c.g
		dlight.b = c.b
		dlight.Brightness = 8
		dlight.Decay = size * 5
		dlight.Size = size
		dlight.DieTime = CurTime() + 1
	end
end)

function ENT:AddRoundThing(pos)
	self.roundthings[pos]=util.GetPixelVisibleHandle()
end


ENT:AddHook("Initialize", "spritetest", function(self)
	self.roundthingmat=Material("sprites/light_ignorez")
	self.roundthings={}
	self:AddRoundThing(Vector(-257,-383,222.5))
	--self:AddRoundThing(Vector(-324.74,-310.87,222.5))
	--self:AddRoundThing(Vector(-371.58,-271.56,222.5))
	--self:AddRoundThing(Vector(-402.3,-175.17,222.5))
	--self:AddRoundThing(Vector(-418.7,-123.74,222.5))
	--self:AddRoundThing(Vector(-449.7,-26.48,222.5))
	--self:AddRoundThing(Vector(-444.74,29.44,222.5))
	--self:AddRoundThing(Vector(-414.83,123.27,222.5))
	--self:AddRoundThing(Vector(-398.5,174.51,222.5))
	--self:AddRoundThing(Vector(-363.36,269.67,222.5))
	--self:AddRoundThing(Vector(-318.57,302.84,222.5))
	--self:AddRoundThing(Vector(-237.87,362.61,222.5))
	--self:AddRoundThing(Vector(-196.91,392.94,222.5))
	--self:AddRoundThing(Vector(-103.69,432.7,222.5))
	--self:AddRoundThing(Vector(-51.12,432.7,222.5))
	self:AddRoundThing(Vector(51.75,460,222.5))
	--self:AddRoundThing(Vector(104.76,432.7,222.5))
	--self:AddRoundThing(Vector(198.82,386.66,222.5))
	--self:AddRoundThing(Vector(238.42,357.33,222.5))
	--self:AddRoundThing(Vector(317.29,301.46,222.5))
	--self:AddRoundThing(Vector(366.49,269.05,222.5))
	--self:AddRoundThing(Vector(396.84,173.72,222.5))
	--self:AddRoundThing(Vector(413.4,122.04,222.5))
	--self:AddRoundThing(Vector(444.76,24.65,222.5))
	--self:AddRoundThing(Vector(446.2,-28.22,222.5))
	--self:AddRoundThing(Vector(414.35,-116.72,222.5))
	--self:AddRoundThing(Vector(396.13,-173.9,222.5))
	--self:AddRoundThing(Vector(365.36,-270.42,222.5))
	--self:AddRoundThing(Vector(321.86,-308.13,222.5))
	--self:AddRoundThing(Vector(242.69,-366.76,222.5))
end)

local size=32
ENT:AddHook("Draw", "spritetest", function(self)
	for k,v in pairs(self.roundthings) do
		local pos = self:LocalToWorld(k)
		local vis = util.PixelVisible(pos, 3, v)*255
		if vis > 0 then
			render.SetMaterial(self.roundthingmat)
			render.DrawSprite(pos, size, size, Color(255,153,0, vis))
		end
	end
end)