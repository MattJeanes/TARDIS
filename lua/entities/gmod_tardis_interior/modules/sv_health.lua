ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
    local newhealth = self.exterior:GetHealth() - (dmginfo:GetDamage()/2)
    self.exterior:ChangeHealth(newhealth)
end)