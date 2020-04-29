--Health

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
    --local max_health = self:GetSetting("health-max") or 100
    self:SetData("health-val", TARDIS:GetSetting("health-max"), true)
end)
function ENT:ChangeHealth(NewHealth)
    if self:GetData("repairing", false) then
        return
    end
    local OldHealth = self:GetHealth()
    if NewHealth <= 0 then 
        NewHealth = 0
        if NewHealth == 0 and not ( NewHealth == OldHealth) then
            self:CallHook("health-depleted")
            self.interior:CallHook("health-depleted")
        end
    end
    self:SetData("health-val", NewHealth, true)
    self:CallHook("health-change")
end

function ENT:GetHealth()
    return self:GetData("health-val", 0)
end

function ENT:GetRepairTime()
    return self:GetData("repair-time")-CurTime()
end

if SERVER then

    function ENT:Explode()
        if not vFireInstalled then
            local explode = ents.Create("env_explosion")
            explode:SetPos( self:LocalToWorld(Vector(0,0,50)) ) //Puts the explosion where you are aiming
            explode:SetOwner( self ) //Sets the owner of the explosion
            explode:Spawn()
            explode:SetKeyValue("iMagnitude","100") //Sets the magnitude of the explosion
            explode:Fire("Explode", 0, 0 ) //Tells the explode entity to explode
            //explode:EmitSound("weapon_AWP.Single", 400, 400 ) //Adds sound to the explosion
        else
            //alternate explosion
        end
    end

    function ENT:ToggleRepair()
        local on = not self:GetData("repair-primed",false)
        self:SetRepair(on)
    end
    function ENT:SetRepair(on)
        //self.interior:SetData("selfrepair-primed",on,true)
        if (self:GetHealth() > TARDIS:GetSetting("health-max",1)-1) or self:GetData("vortex",false) then return end
        if on==true then
            for k,_ in pairs(self.occupants) do
                k:ChatPrint("This TARDIS has been set to self-repair. Please vacate the interior.")
            end
            if self.interior:GetData("power-state") then self.interior:SetPower(!on) end
            self:SetData("repair-primed",on,true)
        else
            self:SetData("repair-primed",on,true)
            self.interior:SetPower(!on)
            for k,_ in pairs(self.occupants) do
                k:ChatPrint("TARDIS self-repair has been cancelled.")
            end
        end
    end

    function ENT:FinishRepair()
        self:EmitSound("tardis/repairfinish.wav")
        self:SetData("repairing", false, true)
        self:ChangeHealth(TARDIS:GetSetting("health-max"))
        self.interior:SetPower(true)
        self:SetLocked(false, nil, true)
        self:GetCreator():ChatPrint("Your TARDIS has finished self-repairing")
        self:FlashLight(1.5)
    end

    ENT:AddHook("CanTogglePower", "health", function(self)
        if (self:GetData("health-val", 0) > 0) and (self:GetData("repairing",false)==false and self:GetData("repair-primed", false)==false) then
            return true
        end
    end)

    ENT:AddHook("CanLock", "repair", function(self)
        if (not self:GetData("repairing",false)) then return true end
    end)

    ENT:AddHook("PlayerExit", "repair", function(self,ply,forced,notp)
        if (self:GetData("repair-primed",false)==true) and (#self.occupants==0) then
            timer.Simple(0.3, function()
                if not IsValid(self) then return end
                self:SetLocked(true)
                local time = CurTime()+( math.Clamp((TARDIS:GetSetting("health-max")-self:GetData("health-val"))*0.1, 1, 60) )
                self:SetData("repair-time", time, true)
                self:SetData("repairing", true, true)
                self:SetData("repair-primed", false)
            end)
        end
    end)
    
    ENT:AddHook("Think", "repair", function(self)
        if (self:GetData("repairing",false) and CurTime()>self:GetData("repair-time",0)) then
            self:FinishRepair()
        end
    end)

    ENT:AddHook("OnTakeDamage", "Health", function(self, dmginfo)
        local newhealth = self:GetHealth() - (dmginfo:GetDamage()/2)
        self:ChangeHealth(newhealth)
    end)

    ENT:AddHook("PhysicsCollide", "Health", function(self, data, collider)
        if ( data.Speed < 300 ) then return end
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