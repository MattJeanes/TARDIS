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
end)
function ENT:ChangeHealth(newhealth)
    if not TARDIS:GetSetting("health-enabled") then return end
    if self:GetData("repairing", false) then
        return
    end
    local oldhealth = self:GetHealth()
    if newhealth <= 0 then
        newhealth = 0
        if newhealth == 0 and not (newhealth == oldhealth) then
            self:CallHook("health-depleted")
            self.interior:CallHook("health-depleted")
        end
    end
    self:SetData("health-val", newhealth, true)
    self:CallHook("health-change")
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

function ENT:GetRepairTime()
    return self:GetData("repair-time")-CurTime()
end

if SERVER then
    cvars.AddChangeCallback("tardisrw_maxhealth", function(cvname, oldvalue, newvalue)
       TARDIS:SetSetting("health-max", tonumber(newvalue), true)
    end, "UpdateOnChange")

    cvars.AddChangeCallback("tardisrw_damage", function(cvname, oldvalue, newvalue)
       TARDIS:SetSetting("health-enabled", tobool(newvalue), true)
    end, "UpdateOnChange")

    function ENT:Explode()
        local explode = ents.Create("env_explosion")
        explode:SetPos( self:LocalToWorld(Vector(0,0,50)) )
        explode:SetOwner( self )
        explode:Spawn()
        explode:SetKeyValue("iMagnitude","100")
        explode:Fire("Explode", 0, 0 )
    end

    function ENT:ToggleRepair()
        local on = not self:GetData("repair-primed",false)
        self:SetRepair(on)
    end
    function ENT:SetRepair(on)
        if (self:GetHealth() > TARDIS:GetSetting("health-max",1)-1) or self:GetData("vortex",false) then return end
        if on==true then
            for k,_ in pairs(self.occupants) do
                k:ChatPrint("This TARDIS has been set to self-repair. Please vacate the interior.")
            end
            if self:GetData("power-state") then self:SetPower(false) end
            self:SetData("repair-primed",true,true)
        else
            self:SetData("repair-primed",false,true)
            self.interior:SetPower(true)
            for k,_ in pairs(self.occupants) do
                k:ChatPrint("TARDIS self-repair has been cancelled.")
            end
        end
    end

    function ENT:StartRepair()
        if not IsValid(self) then return end
        self:SetLocked(true)
        local time = CurTime()+(math.Clamp((TARDIS:GetSetting("health-max")-self:GetData("health-val"))*0.1, 1, 60))
        self:SetData("repair-time", time, true)
        self:SetData("repairing", true, true)
        self:SetData("repair-primed", false)
    end

    function ENT:FinishRepair()
        self:EmitSound(self.metadata.Exterior.Sounds.RepairFinish)
        self:SetData("repairing", false, true)
        self:ChangeHealth(TARDIS:GetSetting("health-max"))
        self.interior:SetPower(true)
        self:SetLocked(false, nil, true)
        self:GetCreator():ChatPrint("Your TARDIS has finished self-repairing")
        self:FlashLight(1.5)
    end

    ENT:AddHook("CanTogglePower", "health", function(self)
        if (not (self:GetData("health-val", 0) > 0)) or (self:GetData("repairing",false) or self:GetData("repair-primed", false)) then
            return false
        end
    end)

    ENT:AddHook("CanLock", "repair", function(self)
        if (not self:GetData("repairing",false)) then return true end
    end)

    ENT:AddHook("PlayerExit", "repair", function(self,ply,forced,notp)
        -- hacky af because occupant table gets updated too late for this, and as a result, when the last player exits, the count is still 1
        if (self:GetData("repair-primed",false)==true) and (table.Count(self.occupants)==1 and table.GetFirstKey(self.occupants) == ply) then
            self:SetData("repair-shouldstart", true)
            self:SetData("repair-delay", CurTime()+0.3)
        end
    end)

    ENT:AddHook("PlayerEnter", "repair", function(self,ply,forced,notp)
        print(#self.occupants)
        if (self:GetData("repair-primed",false)==true) and table.Count(self.occupants)>=0 then
            self:SetData("repair-shouldstart", false)
        end
    end)

    ENT:AddHook("Think", "repair", function(self)
        if self:GetData("repair-primed",false) and self:GetData("repair-shouldstart") and CurTime() > self:GetData("repair-delay") then
            self:SetData("repair-shouldstart", false)
            self:StartRepair()
        end

        if (self:GetData("repairing",false) and CurTime()>self:GetData("repair-time",0)) then
            self:FinishRepair()
        end
    end)

    ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
        local newhealth = self:GetHealth() - (dmginfo:GetDamage()/2)
        self:ChangeHealth(newhealth)
    end)

    ENT:AddHook("PhysicsCollide", "Health", function(self, data, collider)
        if (data.Speed < 300) then return end
        local newhealth = self:GetHealth() - data.Speed / 23
        self:ChangeHealth(newhealth)
    end)

    ENT:AddHook("health-change", "FallbackNetwork", function(self)
        local health = self:GetData("health-val")
        self:SendMessage("health-networking", function()
            net.WriteInt(health, 32)
        end)
    end)

    ENT:AddHook("health-depleted", "death", function(self)
        self.interior:SetPower(false)
        if self:GetData("vortex",false) then
            self:Mat()
        end
        self:Explode()
    end)
else
    ENT:OnMessage("health-networking", function(self, ply)
        local newhealth = net.ReadInt(32)
        self:ChangeHealth(newhealth)
        self:SetData("UpdateHealthScreen", true, true)
    end)
end
