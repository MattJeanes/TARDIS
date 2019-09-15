ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
    local newhealth = self.exterior:GetHealth() - dmginfo:GetDamage()
    self.exterior:ChangeHealth(newhealth)
end)