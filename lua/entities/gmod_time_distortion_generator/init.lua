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

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use(ply)
    if self.broken then return end

    local on = not self:GetEnabled()
    local phys = self:GetPhysicsObject()
    self.on = false

    if on and self.FlyTime == nil then
        TARDIS:Message(ply, "Starting the time distortion generator...")
        self:SetColor(Color(255, 166, 0))
        phys:SetAngleVelocity(Vector(20, -20, -10))
        phys:EnableGravity(false)
        phys:SetVelocity(Vector(0, 0, 15))

        sound.Play("drmatt/tardis/seq_ok.wav", self:GetPos())

        self.FlyTime = CurTime()
        self.LastActivator = ply
    else
        self.FlyTime = nil
        self:SetEnabled(false)
        TARDIS:Message(ply, "Time distortion generator disabled.")
        self:SetColor(Color(255, 255, 255, 255))
        phys:EnableGravity(true)

        sound.Play("drmatt/tardis/seq_bad.wav", self:GetPos())

        local effect_data = EffectData()
        effect_data:SetOrigin(self:GetPos())
        util.Effect("cball_explode", effect_data)

    end
end

function ENT:Think()
    if self.broken then return end
    if self.on then
        local phys = self:GetPhysicsObject()
        phys:SetAngleVelocity(Vector(180, -200, -190))
        phys:AddVelocity(-0.2 * phys:GetVelocity())
    end
    if self.FlyTime ~= nil and CurTime() - self.FlyTime > 3 then
        self.FlyTime = nil
        self.on = true
        self:SetEnabled(true)
        TARDIS:Message(self.LastActivator, "Time distortion generator enabled.")
        self:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
        self:SetColor(Color(164, 90, 250))

        sound.Play("drmatt/tardis/power_on.wav", self:GetPos())

        for i,v in ipairs(ents.FindByClass("gmod_tardis_interior")) do
            if v:GetPos():Distance(self:GetPos()) <= v.metadata.Interior.ExitDistance then
                for occ,_ in pairs(v.occupants) do
                    TARDIS:ErrorMessage(occ, "WARNING: Something is causing time distortions inside this TARDIS")
                end
                break
            end
        end
    end
end

function ENT:Break()
    self.on = false
    self.FlyTime = nil
    self.broken = true
    self:SetEnabled(false)
    self:SetColor(Color(100, 100, 100, 255))
    self:GetPhysicsObject():EnableGravity(true)

    local effect_data = EffectData()
    effect_data:SetOrigin(self:GetPos())
    effect_data:SetMagnitude(10)
    util.Effect("Explosion", effect_data)
end

function ENT:OnTakeDamage(dmg)
    if self.on or self.FlyTime ~= nil then
        self:Break()
    end
end