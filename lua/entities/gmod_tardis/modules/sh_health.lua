-- Health

ENT:AddHook("Initialize","health-init",function(self)
    self:SetData("health-val", TARDIS:GetSetting("health-max"), true)
    if SERVER and WireLib then
        self:TriggerWireOutput("Health", self:GetHealth())
    end
end)

ENT:AddHook("SettingChanged","maxhealth-changed", function(self, id, val)
    if id ~= "health-max" then return end

    if self:GetHealth() > val then
        self:ChangeHealth(val)
    end
end)

function ENT:ChangeHealth(newhealth)
    if self:GetData("repairing", false) then
        return
    end
    local maxhealth = TARDIS:GetSetting("health-max")
    if not TARDIS:GetSetting("health-enabled") then
        self:SetData("health-val", maxhealth, true)
        return
    end
    local oldhealth = self:GetHealth()
    if newhealth > oldhealth and oldhealth+newhealth > maxhealth then
        newhealth = maxhealth
    end
    if newhealth <= 0 then
        newhealth = 0
        if newhealth ~= oldhealth then
            self:CallCommonHook("OnHealthDepleted")
        end
    end
    self:SetData("health-val", newhealth, true)
    self:CallCommonHook("OnHealthChange", newhealth, oldhealth)
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

function ENT:GetHealthPercent()
    local val = self:GetData("health-val", 0)
    local percent = (val * 100)/TARDIS:GetSetting("health-max")
    return percent
end

function ENT:GetRepairTime()
    return self:GetData("repair-time")-CurTime()
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
        local on = not self:GetData("repair-primed",false)
        return self:SetRepair(on)
    end
    function ENT:SetRepair(on)
        if not TARDIS:GetSetting("health-enabled")
            and self:GetHealth() ~= TARDIS:GetSetting("health-max")
        then
            self:ChangeHealth(TARDIS:GetSetting("health-max"))
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
        local maxhealth = TARDIS:GetSetting("health-max")
        local curhealth = self:GetData("health-val")
        local maxtime = TARDIS:GetSetting("long_repair") and 60 or 15
        local repairtime = math.Clamp(maxtime * (maxhealth - curhealth) / maxhealth, 1, maxtime)

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
        self:ChangeHealth(TARDIS:GetSetting("health-max"))
        self:CallHook("RepairFinished")
        self:SetPower(true)
        self:SetLocked(false, nil, true)
        TARDIS:Message(self:GetCreator(), "Health.RepairFinished")
        self:StopSmoke()
        self:FlashLight(1.5)
    end

    function ENT:StartSmoke()
        local smoke = ents.Create("env_smokestack")
        smoke:SetPos(self:LocalToWorld(Vector(0,0,80)))
        smoke:SetAngles(self:GetAngles()+Angle(-90,0,0))
        smoke:SetKeyValue("InitialState", "1")
        smoke:SetKeyValue("WindAngle", "0 0 0")
        smoke:SetKeyValue("WindSpeed", "0")
        smoke:SetKeyValue("rendercolor", "50 50 50")
        smoke:SetKeyValue("renderamt", "170")
        smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
        smoke:SetKeyValue("BaseSpread", "5")
        smoke:SetKeyValue("SpreadSpeed", "10")
        smoke:SetKeyValue("Speed", "50")
        smoke:SetKeyValue("StartSize", "30")
        smoke:SetKeyValue("EndSize", "70")
        smoke:SetKeyValue("roll", "20")
        smoke:SetKeyValue("Rate", "10")
        smoke:SetKeyValue("JetLength", "100")
        smoke:SetKeyValue("twist", "5")
        smoke:Spawn()
        smoke:SetParent(self)
        smoke:Activate()
        self.smoke=smoke
    end

    function ENT:StopSmoke()
        if self.smoke and IsValid(self.smoke) and self:GetData("smoke-killdelay")==nil then
            self.smoke:Fire("TurnOff")
            local jetlength = self.smoke:GetInternalVariable("JetLength")
            local speed = self.smoke:GetInternalVariable("Speed")
            self:SetData("smoke-killdelay",CurTime()+(speed/jetlength)*5)
        end
    end

    ENT:AddHook("CanRepair", "health", function(self, ignore_health)
        if (self:GetHealth() >= TARDIS:GetSetting("health-max"))
            and not ignore_health and not self:GetData("redecorate")
        then
            return false
        end
    end)

    ENT:AddHook("CanTogglePower", "health", function(self)
        if (not (self:GetData("health-val", 0) > 0)) or (self:GetData("repairing",false) or self:GetData("repair-primed", false)) then
            return false
        end
    end)

    ENT:AddHook("CanLock", "repair", function(self)
        if (not self:GetData("repairing",false)) then return true end
    end)

    ENT:AddHook("PostPlayerExit", "repair", function(self,ply,forced,notp)
        if (self:GetData("repair-primed",false)==true) and (table.IsEmpty(self.occupants)) then
            self:SetData("repair-shouldstart", true)
            self:SetData("repair-delay", CurTime()+0.3)
        end
    end)

    ENT:AddHook("PlayerEnter", "repair", function(self,ply,forced,notp)
        if (self:GetData("repair-primed",false)==true) and table.Count(self.occupants)>=0 then
            self:SetData("repair-shouldstart", false)
        end
    end)

    ENT:AddHook("LockedUse", "repair", function(self, a)
        if self:GetData("repairing") then
            TARDIS:Message(a, "Health.Repairing", math.floor(self:GetRepairTime()))
            return true
        end
    end)

    ENT:AddHook("Think", "repair", function(self)
        if self:GetData("repair-primed", false) and self:CallHook("CanRepair") == false then
            self:SetData("repair-primed", false, true)
            self:SetPower(true)
            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "Health.RepairCancelled")
            end
        end

        if self:GetData("repair-primed",false) and self:GetData("repair-shouldstart") and CurTime() > self:GetData("repair-delay") then
            self:SetData("repair-shouldstart", false)
            self:StartRepair()
        end

        if (self:GetData("repairing",false) and CurTime()>self:GetData("repair-time",0)) then
            self:FinishRepair()
        end
    end)

    ENT:AddHook("Think", "health-warning", function(self)
        if self:CallHook("ShouldStartSmoke") and self:CallHook("ShouldStopSmoke")~=true then
            if self.smoke then return end
            self:StartSmoke()
        else
            self:StopSmoke()
        end
    end)

    ENT:AddHook("Think", "RemoveSmoke", function(self)
        local smokedelay = self:GetData("smoke-killdelay")
        if smokedelay ~= nil and CurTime() >= smokedelay then
            if IsValid(self.smoke) then
                self.smoke:Remove()
                self.smoke = nil
                self:SetData("smoke-killdelay",nil)
            end
        end
    end)

    ENT:AddHook("ShouldStartSmoke", "health-warning", function(self)
        if self:GetData("health-warning",false) then
            return true
        end
    end)

    ENT:AddHook("ShouldTakeDamage", "health", function(self, dmginfo)
        if not TARDIS:GetSetting("health-enabled") then return false end
    end)

    ENT:AddHook("ShouldTakeDamage", "repair", function(self, dmginfo)
        if self:GetData("repairing",false) then return false end
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
        local newhealth = self:GetHealth() - (dmginfo:GetDamage()/2)
        self:ChangeHealth(newhealth)
        if not IsValid(self.interior) then return end
        if dmginfo:IsDamageType(DMG_BLAST) and self:GetHealth() ~= 0 then
            int = self.metadata.Interior.Sounds.Damage
            self.interior:EmitSound(int.Explosion)
        end
    end)

    ENT:AddHook("PhysicsCollide", "Health", function(self, data, collider)
        if not TARDIS:GetSetting("health-enabled") then return end
        if (data.Speed < 300) then return end
        local newhealth = self:GetHealth() - (data.Speed / 23)
        self:ChangeHealth(newhealth)
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
        if self:GetHealthPercent() <= 20 and (not self:GetData("health-warning",false)) then
            self:SetData("health-warning", true, true)
            self:CallCommonHook("HealthWarningToggled",true)
        end
    end)

    ENT:AddHook("OnHealthChange", "warning-stop", function(self)
        if self:GetHealthPercent() > 20 and (self:GetData("health-warning",false)) then
            self:SetData("health-warning", false, true)
            self:CallCommonHook("HealthWarningToggled", false)
        end
    end)

    ENT:AddHook("HealthWarningToggled", "client", function(self, on)
        self:SendMessage("health_warning_toggled", {on})
    end)

    ENT:AddHook("HandleE2", "health", function(self, name, e2, ...)
        local args = {...}
        if name == "GetHealth" then
            return self:GetHealthPercent()
        elseif name == "Selfrepair" and TARDIS:CheckPP(e2.player, self) then
            self:ToggleRepair()
            return self:GetData("repair-primed",false) and 1 or 0
        elseif name == "SetSelfrepair" and TARDIS:CheckPP(e2.player, self) then
            local on = args[1]
            if on == 1 then
                if self:GetData("repair-primed",false) == false then
                    return self:SetRepair(true) and 1 or 0
                end
            else
                if self:GetData("repair-primed",false) == true then
                    return self:SetRepair(false) and 1 or 0
                end
            end
        elseif name == "GetSelfrepairing" then
            local repairing = self:GetData("repairing",false)
            local primed = self:GetData("repair-primed",false)
            if repairing then
                return 1
            elseif primed then
                return 2
            else
                return 0
            end
        elseif name == "GetRepairTime" then
            if self:GetData("repairing",false) then
                return self:GetRepairTime()
            end
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "repair", function(self)
        if self:GetData("repair-primed") or self:GetData("repairing") then
            return false
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "health", function(self)
        if self:GetHealth() == 0 then return false end
    end)
else
    ENT:OnMessage("health_warning_toggled", function(self, data, ply)
        self:CallCommonHook("HealthWarningToggled", data[1])
    end)
end
