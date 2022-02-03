-- Health

CreateConVar("tardis2_maxhealth", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - Maximum health")
CreateConVar("tardis2_damage", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "TARDIS - Damage enabled (1 enables, 0 disables)", 0, 1)

TARDIS:AddSetting({
    id="health-enabled",
    name="Enable Health",
    desc="Should the TARDIS have health and take damage?",
    section="Health",
    value=true,
    type="bool",
    setting=true,
    networked=true
})

TARDIS:AddSetting({
    id="health-max",
    name="Max Health",
    desc="Maximum ammount of health the TARDIS has",
    section="Misc",
    type="number",
    value=1000,
    min=1,
    max=50000,
    networked=true
})

ENT:AddHook("Initialize","health-init",function(self)
    self:SetData("health-val", TARDIS:GetSetting("health-max"), true)
    if SERVER and WireLib then
        self:TriggerWireOutput("Health", self:GetHealth())
    end
end)

function ENT:ChangeHealth(newhealth)
    if self:GetData("repairing", false) then
        return
    end
    local maxhealth = TARDIS:GetSetting("health-max")
    local oldhealth = self:GetHealth()
    if newhealth > oldhealth and oldhealth+newhealth > maxhealth then
        newhealth = maxhealth
    end
    if newhealth <= 0 then
        newhealth = 0
        if newhealth == 0 and not (newhealth == oldhealth) then
            self:CallHook("OnHealthDepleted")
            if self.interior then self.interior:CallHook("OnHealthDepleted") end
        end
    end
    self:SetData("health-val", newhealth, true)
    self:CallHook("OnHealthChange", newhealth, oldhealth)
    if self.interior then self.interior:CallHook("OnHealthChange", newhealth, oldhealth) end
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

function ENT:GetHealthPercent()
    local val = self:GetData("health-val", 0)
    local percent = (val * 100)/TARDIS:GetSetting("health-max",1)
    return percent
end

function ENT:GetRepairTime()
    return self:GetData("repair-time")-CurTime()
end

if SERVER then
    cvars.AddChangeCallback("tardis2_maxhealth", function(cvname, oldvalue, newvalue)
        local nvnum = tonumber(newvalue)
        if nvnum < 0 then
            nvnum = 1
        end
        TARDIS:SetSetting("health-max", nvnum, true)
        for k,v in pairs(ents.FindByClass("gmod_tardis")) do
            if v:GetHealth() > nvnum then
                v:ChangeHealth(nvnum)
            end
        end
    end, "UpdateOnChange")

    cvars.AddChangeCallback("tardis2_damage", function(cvname, oldvalue, newvalue)
       TARDIS:SetSetting("health-enabled", tobool(newvalue), true)
    end, "UpdateOnChange")

    ENT:AddWireOutput("Health", "TARDIS Health")

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
        if not TARDIS:GetSetting("health-enabled") and self:GetHealth()~=TARDIS:GetSetting("health-max",1) then 
            self:ChangeHealth(TARDIS:GetSetting("health-max"),1)
            return false
        end
        if self:CallHook("CanRepair")==false then return false end
        if on==true then
            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "This TARDIS has been set to self-repair. Please vacate the interior.")
            end
            if self:GetPower() then self:SetPower(false) end
            self:SetData("repair-primed",true,true)

            if table.IsEmpty(self.occupants) then
                self:Timer("repair-nooccupants", 0, function() 
                    self:SetData("repair-shouldstart", true)
                    self:SetData("repair-delay", CurTime()+0.3)
                end)
            end
        else
            self:SetData("repair-primed",false,true)
            self:SetPower(true)
            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "Self-repair has been cancelled.")
            end
        end
        return true
    end

    function ENT:StartRepair()
        if not IsValid(self) then return end
        self:SetLocked(true,nil,true)
        local time = CurTime()+(math.Clamp((TARDIS:GetSetting("health-max")-self:GetData("health-val"))*0.1, 1, 60))
        self:SetData("repair-time", time, true)
        self:SetData("repairing", true, true)
        self:SetData("repair-primed", false, true)
        self:CallHook("RepairStarted")
    end

    function ENT:FinishRepair()
        if self:CallHook("ShouldRedecorate") and self:Redecorate() then
            
            return
        end
        self:EmitSound(self.metadata.Exterior.Sounds.RepairFinish)
        self:SetData("repairing", false, true)
        self:ChangeHealth(TARDIS:GetSetting("health-max"))
        self:CallHook("RepairFinished")
        self:SetPower(true)
        self:SetLocked(false, nil, true)
        TARDIS:Message(self:GetCreator(), "Your TARDIS has finished self-repairing")
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

    ENT:AddHook("CanRepair", "health", function(self)
        if self:GetData("vortex", false) then return false end
        if (self:GetHealth() >= TARDIS:GetSetting("health-max", 1))
            and not self:CallHook("ShouldRedecorate")
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
            TARDIS:Message(a, "This TARDIS is repairing. It will be done in "..math.floor(self:GetRepairTime()).." seconds.")
            return true
        end
    end)

    ENT:AddHook("Think", "repair", function(self)
        if self:GetData("repair-primed", false) and self:CallHook("CanRepair") == false then
            self:SetData("repair-primed", false, true)
            self:SetPower(true)
            for k,_ in pairs(self.occupants) do
                TARDIS:Message(k, "Self-repair has been cancelled.")
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

    ENT:AddHook("ShouldTakeDamage", "Health", function(self, dmginfo)
        if not TARDIS:GetSetting("health-enabled") then return false end
    end)

    ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
        if dmginfo:GetInflictor():GetClass() == "env_fire" then return end
        if dmginfo:GetDamage() <= 0 then return end
        local newhealth = self:GetHealth() - (dmginfo:GetDamage()/2)
        self:ChangeHealth(newhealth)
    end)

    ENT:AddHook("PhysicsCollide", "Health", function(self, data, collider)
        if not TARDIS:GetSetting("health-enabled") then return end
        if (data.Speed < 300) then return end
        local newhealth = self:GetHealth() - (data.Speed / 23)
        self:ChangeHealth(newhealth)
    end)

    ENT:AddHook("OnHealthChange", "wiremod", function (self)
        self:TriggerWireOutput("Health",self:GetHealth())
    end)

    ENT:AddHook("OnHealthDepleted", "death", function(self)
        self:SetPower(false)
        self:Explode(180)
    end)

    ENT:AddHook("OnHealthChange", "warning", function(self)
        if self:GetHealthPercent() <= 20 and (not self:GetData("health-warning",false)) then
            self:SetData("health-warning", true, true)
            self:CallHook("HealthWarningToggled",true)
            if self.interior then
                self.interior:CallHook("HealthWarningToggled",true)
            end
        end
    end)

    ENT:AddHook("OnHealthChange", "warning-stop", function(self)
        if self:GetHealthPercent() > 20 and (self:GetData("health-warning",false)) then
            self:SetData("health-warning", false, true)
            self:CallHook("HealthWarningToggled",false)
            if self.interior then
                self.interior:CallHook("HealthWarningToggled",false)
            end
        end
    end)

    ENT:AddHook("HandleE2", "health", function(self,name,e2)
        if name == "GetHealth" then
            return self:GetHealthPercent()
        elseif name == "Selfrepair" and TARDIS:CheckPP(e2.player, self) then
            self:ToggleRepair()
            return self:GetData("repair-primed",false) and 1 or 0
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
        end
    end)

end
