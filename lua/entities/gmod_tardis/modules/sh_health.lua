-- Health

function ENT:GetHealthMax()
    local ratio = TARDIS:GetSetting("health_to_shields_ratio")
    return math.max(1, ratio * TARDIS:GetSetting("health_max"))
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

function ENT:IsAlive()
    return (self:GetHealth() ~= 0)
end

function ENT:GetHealthPercent()
    local val = self:GetHealth()
    local percent = (val * 100) / self:GetHealthMax()
    return percent
end

if SERVER then
    ENT:AddHook("Initialize","health-init",function(self)
        self:SetData("health-val", self:GetHealthMax(), true)
        if WireLib then
            self:TriggerWireOutput("Health", self:GetHealth())
        end
    end)

    ENT:AddHook("SettingChanged","maxhealth-changed", function(self, id, val)
        if id ~= "health_max" then return end

        if self:GetHealth() > val then
            self:ChangeHealth(val)
        end
    end)

    function ENT:AddHealth(value)
        local newhealth = self:GetHealth() + value
        self:ChangeHealth(newhealth)
    end

    function ENT:ApplyDamage(dmg)
        local shields = self:GetShields()
        if shields then
            self:AddShieldsLevel(-dmg)
            if shields - dmg < 0 then
                self:AddHealth(shields - dmg)
            end
        else
            self:AddHealth(-dmg)
        end
    end

    function ENT:ChangeHealth(new_health)
        if self:GetRepairing() then
            return
        end
        local max_health = self:GetHealthMax()
        if not TARDIS:GetSetting("health-enabled") then
            self:SetData("health-val", max_health, true)
            return
        end

        local old_health = self:GetHealth()
        new_health = math.Clamp(new_health, 0, max_health)
        self:SetData("health-val", new_health, true)
        self:CallCommonHook("OnHealthChange", new_health, old_health)

        if new_health == 0 and old_health ~= 0 then
            self:CallCommonHook("OnHealthDepleted")
        end
    end

    ENT:AddWireOutput("Health", "Wiremod.Outputs.Health")

    function ENT:Explode(f)
        local force = 60
        if f ~= nil then
            force = tostring(f)
        end
        local explode = ents.Create("env_explosion")
        explode:SetPos( self:LocalToWorld(Vector(0,0,50)) )
        explode:SetOwner( self )
        explode:Spawn()
        explode:SetKeyValue("iMagnitude", force)
        explode:Fire("Explode", 0, 0 )
    end

    ENT:AddHook("CanRepair", "health", function(self, ignore_health)
        if (self:GetHealth() >= self:GetHealthMax())
            and not ignore_health and not self:GetData("redecorate")
        then
            return false
        end
    end)

    ENT:AddHook("CanTogglePower", "health", function(self, on)
        if on and self:GetHealth() <= 0 then
            return false
        end
    end)

    ENT:AddHook("ShouldTakeDamage", "health", function(self, dmginfo)
        if not TARDIS:GetSetting("health-enabled") then return false end
    end)

    ---------------------------------
    --Damage calculation and sounds--
    ---------------------------------

    ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
        if IsValid(dmginfo:GetInflictor())
            and dmginfo:GetInflictor():GetClass() == "env_fire"
        then
            return
        end
        if dmginfo:GetDamage() <= 0 then return end
        self:ApplyDamage(dmginfo:GetDamage() / 2)
        if not IsValid(self.interior) then return end
        if dmginfo:IsDamageType(DMG_BLAST) and self:GetHealth() ~= 0 then
            int = self.metadata.Interior.Sounds.Damage
            self.interior:EmitSound(int.Explosion)
        end
    end)

    ENT:AddHook("PhysicsCollide", "Health", function(self, data, collider)

        if self:IsPlayerHolding() then
            local last_dmg = self:GetData("damage_last_by_ply", 0)
            if CurTime() - last_dmg < 1 then return end
            self:SetData("damage_last_by_ply", CurTime())
        else
            self:SetData("damage_last_by_ply", 0)
        end

        local vert = self:IsVerticalLanding(data)
        local speed_border = vert and 1500 or 300
        local speed_dmg_mult = vert and 0.2 or 1

        if not TARDIS:GetSetting("health-enabled") then return end
        if (data.Speed < speed_border) then return end

        self:ApplyDamage(speed_dmg_mult * data.Speed / 25)

        if not IsValid(self.interior) then return end

        local phys = self:GetPhysicsObject()
        local vel = phys:GetVelocity():Length()

        if self:GetHealth() ~= 0 and vel < 900 then
            int = self.metadata.Interior.Sounds.Damage
            self.interior:EmitSound(int.Crash)
        elseif self:GetHealth() ~= 0 and vel > 900 then
            int = self.metadata.Interior.Sounds.Damage
            self.interior:EmitSound(int.BigCrash)
        end
    end)

    ENT:AddHook("OnHealthChange", "wiremod", function (self)
        self:TriggerWireOutput("Health",self:GetHealth())
    end)

    ENT:AddHook("OnHealthDepleted", "death", function(self)
        if self:GetData("teleport") or self:GetData("vortex") then
            self:InterruptTeleport()
        end
        self:SetPower(false)
        if IsValid(self.interior) then
            local int = self.metadata.Interior.Sounds.Damage
            self.interior:StopSound(int.BigCrash)
            self.interior:StopSound(int.Crash)
            self.interior:StopSound(int.Explosion)
            self.interior:EmitSound(int.Death)
        end
        self:Explode(180)
    end)

    ENT:AddHook("OnHealthChange", "warning", function(self)
        self:UpdateWarning()
    end)

    ENT:AddHook("ShouldWarningBeEnabled","health-warning", function(self)
        if self:GetHealthPercent() <= 20 then
            return true
        end
    end)

    ENT:AddHook("ShouldRegenShields", "health", function(self)
        if not self:IsAlive() then
            return false
        end
    end)

    ENT:AddHook("HandleE2", "health", function(self, name, e2, ...)
        local args = {...}
        if name == "GetHealth" then
            return self:GetHealthPercent()
        end
    end)
end
