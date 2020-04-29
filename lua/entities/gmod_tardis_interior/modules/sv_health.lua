ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
    local newhealth = self.exterior:GetHealth() - (dmginfo:GetDamage()/2)
    self.exterior:ChangeHealth(newhealth)
end)

function ENT:Explode()
    if not vFireInstalled then
        local explode = ents.Create("env_explosion")
        explode:SetPos( self:LocalToWorld(Vector(0,0,0)) ) //Puts the explosion where you are aiming
        explode:SetOwner( self ) //Sets the owner of the explosion
        explode:Spawn()
        explode:SetKeyValue("iMagnitude","100") //Sets the magnitude of the explosion
        explode:Fire("Explode", 0, 0 ) //Tells the explode entity to explode
        //explode:EmitSound("weapon_AWP.Single", 400, 400 ) //Adds sound to the explosion
    else
        //Alternate Explosion
    end
end

ENT:AddHook("health-depleted", "interior-death", function(self)
    util.ScreenShake(self:GetPos(), 10, 10, 1, 10)
    self:Explode()
end)