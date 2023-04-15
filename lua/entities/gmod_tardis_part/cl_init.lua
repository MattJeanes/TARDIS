include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()

end

function ENT:BeingLookedAtByLocalPlayer(distance)
    local ply = LocalPlayer()
    if ( !IsValid( ply ) ) then return false end

    local view = ply:GetViewEntity()
    local dist = distance or 256
    dist = dist * dist

    -- If we're not spectating a player, perform a manual trace from the entity's position --
    local pos = view:GetPos()

    if ( pos:DistToSqr( self:GetPos() ) <= dist ) then
        return util.TraceLine( {
            start = pos,
            endpos = pos + ( view:GetAngles():Forward() * dist ),
            filter = view
        } ).Entity == self
    end

    return false
end