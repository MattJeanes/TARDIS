ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
    local newhealth = self.exterior:GetHealth() - (dmginfo:GetDamage()/2)
    self.exterior:ChangeHealth(newhealth)
end)

ENT:AddHook("Initialize", "Health", function(self)
    self.CloisterLoop = CreateSound(self, self.metadata.Interior.Sounds.Cloister)
end)

ENT:AddHook("OnRemove", "Health", function(self)
    self:StopCloisters()
    self.CloisterLoop = null
end)

function ENT:Explode()
    local explode = ents.Create("env_explosion")
    explode:SetPos( self:LocalToWorld(Vector(0,0,0)) )
    explode:SetOwner( self )
    explode:Spawn()
    explode:Fire("Explode", 0, 0 )
end

function ENT:StartCloisters()
    self.CloisterLoop:Play()
end

function ENT:StopCloisters()
    self.CloisterLoop:Stop()
end

ENT:AddHook("OnHealthDepleted", "interior-death", function(self)
    util.ScreenShake(self:GetPos(), 10, 10, 1, 10)
    self:Explode()
end)

ENT:AddHook("ShouldTakeDamage", "DamageOff", function(self, dmginfo)
    if not TARDIS:GetSetting("health-enabled") then return false end
end)