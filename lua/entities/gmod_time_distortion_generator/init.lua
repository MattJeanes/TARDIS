-- Time distortion generator by parar020100 and JEREDEK

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)

    self:SetName("TimeDistortionGenerator")
    self:SetColor(Color(255, 255, 255, 255))
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    self.Radius = 1000
    self.EntHealth = 100
    self.EntMaxHealth = 100

    if (phys:IsValid()) then
        phys:Wake()
    end

    if not WireLib then 
        return 
    else
        local inNames = {"Activate","Radius"}
	    local inTypes = {"NORMAL","NORMAL"}
	    WireLib.CreateSpecialInputs( self,inNames,inTypes)
        Wire_CreateOutputs(self,{"Active","Radius","Health"})

        Wire_TriggerOutput(self,"Radius",1000)
    end
end

function ENT:TriggerWire(tname,value)
    if(not WireLib) then
        return
    else
        Wire_TriggerOutput(self,tname,value)
    end
end

function ENT:TriggerInput(iname, value)
    if(iname == "Activate") then
        if self.Broken then return end

        if(value >= 1) then
            if(self:GetEnabled() == false) then
                self:TurnOn(true)
            end
        else
            if(self:GetEnabled() == true) then
                self:TurnOn(false)
                Wire_TriggerOutput(self,"Active",0)
            end
        end
    elseif(iname == "Radius") then
        self.Radius = math.Clamp(value,0,2048)
        Wire_TriggerOutput(self,"Radius",self.Radius)
    end
end

function ENT:TurnOn(active)
    if self.Broken then return end

    local phys = self:GetPhysicsObject()

    if(active and not timer.Exists("tdg_enable_timer")) then
        self:SetColor(Color(255, 166, 0))
        phys:SetAngleVelocity(Vector(20, -20, -10))
        phys:EnableGravity(false)
        phys:SetVelocity(Vector(0, 0, 15))

        sound.Play("drmatt/tardis/seq_ok.wav", self:GetPos())

        timer.Create("tdg_enable_timer",3,1,function()
            self.On = true
    
            TARDIS:Message(self.LastActivator, "TimeDistortionGenerator.Enabled")
    
            self:SetEnabled(true)
            self:TriggerWire("Active",1)
            self:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
            self:SetColor(Color(164, 90, 250))
    
            sound.Play("drmatt/tardis/power_on.wav", self:GetPos())
    
            for i,v in ipairs(ents.FindByClass("gmod_tardis_interior")) do
                if v:GetPos():Distance(self:GetPos()) <= v.metadata.Interior.ExitDistance then
                    for occ,_ in pairs(v.occupants) do
                        TARDIS:ErrorMessage(occ, "TimeDistortionGenerator.Distortions")
                    end
                    break
                end
            end
        end)
    else
        timer.Remove("tdg_enable_timer")
        
        self.On = false
        self:SetEnabled(false)
        self:TriggerWire("Active",0)
        self:SetColor(Color(255, 255, 255, 255))

        phys:EnableGravity(true)

        sound.Play("drmatt/tardis/seq_bad.wav", self:GetPos())

        local effect_data = EffectData()
        effect_data:SetOrigin(self:GetPos())
        util.Effect("cball_explode", effect_data)
    end
end

function ENT:Use(ply)
    if self.Broken then return end

    self.LastActivator = ply

    if(self:GetEnabled()) then
        TARDIS:Message(ply, "TimeDistortionGenerator.Disabled")
        self:TurnOn(false)
    else
        TARDIS:Message(ply, "TimeDistortionGenerator.Starting")
        self:TurnOn(true)
    end

    
end

function ENT:Think()
    if self.Broken then return end

    if(self.On) then
        local phys = self:GetPhysicsObject()
        if(phys:IsMotionEnabled()) then
            phys:SetAngleVelocity(Vector(180, -200, -190))
            phys:AddVelocity(-0.2 * phys:GetVelocity())
        end
    end
end

function ENT:Break()
    self.On = false
    self.Broken = true

    self:SetEnabled(false)
    self:SetColor(Color(100, 100, 100, 255))
    self:GetPhysicsObject():EnableGravity(true)

    self:TriggerWire("Active",0)

    local effect_data = EffectData()
    effect_data:SetOrigin(self:GetPos())
    effect_data:SetMagnitude(10)
    util.Effect("Explosion", effect_data)
end

function ENT:OnTakeDamage(damage)
    if(self.Broken) then return end

    local dmg = damage:GetDamage()
    
    self.EntHealth = math.Clamp(self.EntHealth - dmg,0,self.EntMaxHealth)

    self:TriggerWire("Health",self.EntHealth)
    
    if(self.EntHealth <= 0) then
        self:Break()
    end
end