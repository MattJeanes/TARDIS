local function rand_offset()
	return math.random(-35, 35)
end

local function get_effect_pos(self)
	local console = self.interior:GetPart("console")
	if self.metadata.Interior.BreakdownEffectPos then
		self.effect_pos = self.interior:GetPos() + self.metadata.Interior.BreakdownEffectPos
	elseif console and IsValid(console) then
		self.effect_pos = console:GetPos() + Vector(0, 0, 50)
	else
		self.effect_pos = self.interior:GetPos() + Vector(0, 0, 50)
	end
end

function ENT:InteriorExplosion()
	if self.effect_pos == nil then
		get_effect_pos(self)
	end

	local function rand_offset() return math.random(-40, 40) end

	local effect_data = EffectData()
	effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(), rand_offset(), 0))

	util.Effect("Explosion", effect_data)

	effect_data:SetScale(0.5)
	effect_data:SetMagnitude(math.random(3, 5))
	effect_data:SetRadius(math.random(1,5))
	util.Effect("ElectricSpark", effect_data)
end

function ENT:InteriorSparks(power)
	if self.effect_pos == nil then
		get_effect_pos(self)
	end

	local effect_data = EffectData()
	effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(), rand_offset(), 0))

	effect_data:SetScale(power)
	effect_data:SetMagnitude(math.random(3, 5) * power)
	effect_data:SetRadius(math.random(1,5) * power)
	util.Effect("ElectricSpark", effect_data)
end