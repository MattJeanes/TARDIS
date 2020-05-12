ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
    local newhealth = self.exterior:GetHealth() - (dmginfo:GetDamage()/2)
    self.exterior:ChangeHealth(newhealth)
end)

function ENT:Explode()
    local explode = ents.Create("env_explosion")
    explode:SetPos( self:LocalToWorld(Vector(0,0,0)) )
    explode:SetOwner( self )
    explode:Spawn()
    explode:Fire("Explode", 0, 0 )
end

ENT:AddHook("health-depleted", "interior-death", function(self)
    util.ScreenShake(self:GetPos(), 10, 10, 1, 10)
    self:Explode()
end)