-- Health

TARDIS.HealthToShieldsRatio = 0.2

function ENT:GetHealthMax()
    return math.max(1, TARDIS.HealthToShieldsRatio * TARDIS:GetSetting("health_max"))
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
end

function ENT:AddHealth(value)
    local newhealth = self:GetHealth() + value
    self:ChangeHealth(newhealth)
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

function ENT:IsAlive()
    return (self:GetHealth() ~= 0)
end

function ENT:GetRepairPrimed()
    return self:GetData("repair-primed",false)
end

function ENT:GetRepairing()
    return self:GetData("repairing",false)
end

function ENT:GetHealthPercent()
    local val = self:GetData("health-val", 0)
    local percent = (val * 100) / self:GetHealthMax()
    return percent
end

function ENT:GetRepairTime()
    return self:GetData("repair-time")-CurTime()
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

if SERVER then
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

    function ENT:ToggleRepair()
        local on = not self:GetRepairPrimed()
        return self:SetRepair(on)
    end
    function ENT:SetRepair(on)
        if not TARDIS:GetSetting("health-enabled")
            and self:GetHealth() ~= self:GetHealthMax()
        then
            self:ChangeHealth(self:GetHealthMax())
            return false
        end

        if self:CallHook("CanRepair") == false then return false end

        if on == true then
            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "Health.RepairActivated")
            end
            local power = self:GetPower()
            self:SetData("power-before-repair", power)
            if power then self:SetPower(false) end
            self:SetData("repair-primed", true, true)

            if table.IsEmpty(self.occupants) then
                self:Timer("repair-nooccupants", 0, function()
                    self:SetData("repair-shouldstart", true)
                    self:SetData("repair-delay", CurTime()+0.3)
                end)
            end
        else
            self:SetData("repair-primed",false,true)
            self:CallCommonHook("RepairCancelled")

            local prev_power = self:GetData("power-before-repair")
            if (prev_power ~= nil) then
                self:SetPower(prev_power)
            else
                self:SetPower(true)
            end

            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "Health.RepairCancelled")
            end
        end
        self:CallHook("RepairToggled", on)
        return true
    end

    function ENT:StartRepair()
        if not IsValid(self) then return end
        self:SetLocked(true,nil,true,true)
        local max_health = self:GetHealthMax()
        local cur_health = self:GetData("health-val")
        local maxtime = TARDIS:GetSetting("long_repair") and 60 or 15
        local repairtime = math.Clamp(maxtime * (max_health - cur_health) / max_health, 1, maxtime)

        local time = CurTime() + repairtime
        self:SetData("repair-time", time, true)
        self:SetData("repairing", true, true)
        self:SetData("repair-primed", false, true)
        self:CallHook("RepairStarted")
    end

    function ENT:FinishRepair()
        if self:GetData("redecorate") and self:Redecorate() then
            return
        end
        self:EmitSound(self.metadata.Exterior.Sounds.RepairFinish)
        self:SetData("repairing", false, true)
        self:ChangeHealth(self:GetHealthMax())
        self:CallHook("RepairFinished")
        self:SetPower(true)
        self:SetLocked(false, nil, true)
        TARDIS:Message(self:GetCreator(), "Health.RepairFinished")
        self:StopSmoke()
        self:FlashLight(1.5)
    end


    ENT:AddHook("CanRepair", "health", function(self, ignore_health)
        if (self:GetHealth() >= self:GetHealthMax())
            and not ignore_health and not self:GetData("redecorate")
        then
            return false
        end
    end)

    ENT:AddHook("CanTogglePower", "health", function(self, on)
        if on and (not (self:GetData("health-val", 0) > 0)) or (self:GetRepairing() or self:GetRepairPrimed()) then
            return false
        end
    end)

    ENT:AddHook("CanLock", "repair", function(self)
        if (not self:GetRepairing()) then return true end
    end)

    ENT:AddHook("PostPlayerExit", "repair", function(self,ply,forced,notp)
        if (self:GetRepairPrimed()==true) and (table.IsEmpty(self.occupants)) then
            self:SetData("repair-shouldstart", true)
            self:SetData("repair-delay", CurTime()+0.3)
        end
    end)

    ENT:AddHook("PlayerEnter", "repair", function(self,ply,forced,notp)
        if (self:GetRepairPrimed()==true) and table.Count(self.occupants)>=0 then
            self:SetData("repair-shouldstart", false)
        end
    end)

    ENT:AddHook("LockedUse", "repair", function(self, a)
        if self:GetRepairing() then
            TARDIS:Message(a, "Health.Repairing", math.floor(self:GetRepairTime()))
            return true
        end
    end)

    ENT:AddHook("Think", "repair", function(self)
        if self:GetRepairPrimed() and self:CallHook("CanRepair") == false then
            self:SetData("repair-primed", false, true)
            self:SetPower(true)
            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "Health.RepairCancelled")
            end
        end

        if self:GetRepairPrimed() and self:GetData("repair-shouldstart") and CurTime() > self:GetData("repair-delay") then
            self:SetData("repair-shouldstart", false)
            self:StartRepair()
        end

        if (self:GetRepairing() and CurTime()>self:GetData("repair-time",0)) then
            self:FinishRepair()
        end
    end)

    ENT:AddHook("ShouldTakeDamage", "health", function(self, dmginfo)
        if not TARDIS:GetSetting("health-enabled") then return false end
    end)

    ENT:AddHook("ShouldTakeDamage", "repair", function(self, dmginfo)
        if self:GetRepairing() then return false end
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

    ENT:AddHook("HandleE2", "health", function(self, name, e2, ...)
        local args = {...}
        if name == "GetHealth" then
            return self:GetHealthPercent()
        elseif name == "Selfrepair" and TARDIS:CheckPP(e2.player, self) then
            return self:ToggleRepair() and 1 or 0
        elseif name == "SetSelfrepair" and TARDIS:CheckPP(e2.player, self) then
            local on = args[1]
            local primed = self:GetRepairPrimed()
            if on == 1 then
                if (not primed) and self:SetRepair(true) then
                    return 1
                end
            else
                if primed and self:SetRepair(false) then
                    return 1
                end
            end
            return 0
        elseif name == "GetSelfrepairing" then
            local repairing = self:GetRepairing()
            local primed = self:GetRepairPrimed()
            if repairing then
                return 1
            elseif primed then
                return 2
            else
                return 0
            end
        elseif name == "GetRepairTime" then
            if self:GetRepairing() then
                return self:GetRepairTime()
            else
                return 0
            end
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "repair", function(self)
        if self:GetRepairPrimed() or self:GetRepairing() then
            return false
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "health", function(self)
        if self:GetHealth() == 0 then return false end
    end)
end
