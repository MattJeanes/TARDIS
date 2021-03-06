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

ENT:AddHook("OnHealthDepleted", "interior-death", function(self)
	util.ScreenShake(self:GetPos(), 10, 10, 1, 10)
	self:Explode()
end)

ENT:AddHook("ShouldTakeDamage", "DamageOff", function(self, dmginfo)
	if not TARDIS:GetSetting("health-enabled") then return false end
end)