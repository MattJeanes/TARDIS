-- TARDIS AI Point
-- Creator: Parar020100

ENT.Base = "base_ai"

ENT.PrintName       = "TARDIS AI point"
ENT.Author          = "parar020100"
ENT.Purpose         = "NPC interactions for the TARDIS"
ENT.Category        = "Doctor Who - TARDIS"
ENT.Spawnable       = false
ENT.AdminOnly       = true

if CLIENT then

    --function ENT:Draw()
    --    self:DrawModel()
    --end

    return
end

function ENT:Initialize()
    if not IsValid(self.tardis) then
        self:Remove()
    end

    self:SetModel(self.tardis:GetModel())

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetRenderMode( RENDERMODE_TRANSALPHA )
    self:SetColor(Color(255,255,255,0))
    self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup( COLLISION_GROUP_WORLD )

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:EnableMotion(false)
    end
end

local enemies = {
    CLASS_COMBINE,
    CLASS_COMBINE_GUNSHIP,
    CLASS_MANHACK,
    CLASS_METROPOLICE,
    CLASS_MILITARY,
    CLASS_SCANNER,
    CLASS_STALKER,
    CLASS_PROTOSNIPER,
    CLASS_COMBINE_HUNTER,
    CLASS_ANTLION,
}

function ENT:Think()
    self:NextThink( CurTime() + 0.1 )

    for k, v in pairs( ents.FindByClass( "npc_*" ) ) do
        if v:IsValid() and v:IsNPC() and v:Classify()
            and v:GetNPCState() and v:GetNPCState() != NPC_STATE_DEAD
            and v:GetPos():Distance( self:GetPos() ) < 5000
        then
            local cl = v:Classify()

            if table.HasValue(enemies,cl) then
                local r1 = v:Disposition(self)
                local r2 = self:Disposition(v)

                local rel = D_HT -- D_FR

                if r1 != rel then
                    v:AddEntityRelationship( self, rel, 99 )
                end
                if r2 != rel then
                    self:AddEntityRelationship( v, rel, 99 )
                end

                v:UpdateEnemyMemory( self, self:GetPos() )

                if !v:GetEnemy() or ( v:GetEnemy() and !v:GetEnemy():IsValid() ) then
                    v:SetEnemy( self )
                    v:SetSchedule( SCHED_CHASE_ENEMY )
                end

                if v:GetEnemy() and v:GetEnemy():IsValid() and v:GetEnemy() == self and v:GetCurrentSchedule() and v:GetCurrentSchedule() == SCHED_ALERT_STAND then
                    self:SetSchedule( SCHED_CHASE_ENEMY )
                end
            end
        end
    end

end

function ENT:OnTakeDamage(dmginfo)
    if self.tardis:CallHook("ShouldTakeDamage",dmginfo)==false then return end
    self.tardis:CallHook("OnTakeDamage", dmginfo)
end
