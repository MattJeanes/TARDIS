ENT:AddHook("Initialize","health-init",function(self)
    --local max_health = self:GetSetting("health-max") or 100
    self:SetData("health-val", 1000, true)
end)
function ENT:ChangeHealth(NewHealth)
    self:SetData("health-val", NewHealth, true)
    self:CallHook("HealthChange")
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

if SERVER then
    ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
        local newhealth = self.exterior:GetHealth() - dmginfo:GetDamage()
        self.exterior:ChangeHealth(newhealth)
    end)

    ENT:AddHook("PhysicsCollide", "Health", function(self, data, collider)
        
    end)

    ENT:AddHook("HealthChange", "FallbackNetwork", function(self)
        local health = self:GetData("health-val")
        self:SendMessage("health-networking", function()
            net.WriteInt(health, 32)
        end)
    end)
else    
    ENT:OnMessage("health-networking", function(self, ply)
        local newhealth = net.ReadInt(32)
        self:ChangeHealth(newhealth)
        self:SetData("UpdateHealthScreen", true, true)
    end)
   -- print("TARDIS - Initialising Health Settings")
    TARDIS:AddSetting({
        id="health-enabled",
        name="Enable Health",
        desc="Should the TARDIS have health and take damage?",
        section="Health",
        value=true,
        type="bool",
        --option=true
        setting=true
    })

    TARDIS:AddSetting({
        id="health-max",
        name="Max Health",
        desc="Maximum ammount of health the TARDIS has",
        section="Misc",
        type="number",
        value=100,
        min=1,
        max=50000
    })
end