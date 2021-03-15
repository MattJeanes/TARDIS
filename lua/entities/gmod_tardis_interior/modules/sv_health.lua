ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
	local newhealth = self.exterior:GetHealth() - (dmginfo:GetDamage()/2)
	self.exterior:ChangeHealth(newhealth)
end)

function ENT:Explode(f)
	local force = tostring(f) or "60"
	local explode = ents.Create("env_explosion")
	explode:SetPos( self:LocalToWorld(Vector(0,0,0)) )
	explode:SetOwner( self )
	explode:Spawn()
	explode:SetKeyValue("iMagnitude", force)
	explode:Fire("Explode", 0, 0 )
end

ENT:AddHook("OnHealthChange", "health", function(self, newhealth, oldhealth)
	if newhealth > oldhealth then return end
	local hp = (oldhealth - newhealth) / 10
	local door = self:GetPart("door")
	if door and IsValid(door) then
		sound.Play("Default.ImpactSoft",door:GetPos())
	end
	util.ScreenShake(self:GetPos(),math.Clamp(hp,0,16),5,0.5,700)
end)

ENT:AddHook("OnHealthDepleted", "interior-death", function(self)
	util.ScreenShake(self:GetPos(), 10, 10, 1, 10)
	self:Explode()
end)

ENT:AddHook("ShouldTakeDamage", "DamageOff", function(self, dmginfo)
	if not TARDIS:GetSetting("health-enabled") then return false end
end)