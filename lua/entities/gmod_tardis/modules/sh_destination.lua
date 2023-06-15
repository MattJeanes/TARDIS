-- Destination

-- Binds

TARDIS:AddKeyBind("destination-open",{
    name="Destination",
    section="ThirdPerson",
    func=function(self,down,ply)
        if down and ply == self.pilot then
            TARDIS:Control("destination", ply)
        end
    end,
    key=KEY_H,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-forward",{
    name="Forward",
    section="Destination",
    key=KEY_W,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-backward",{
    name="Backward",
    section="Destination",
    key=KEY_S,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-left",{
    name="Left",
    section="Destination",
    key=KEY_A,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-right",{
    name="Right",
    section="Destination",
    key=KEY_D,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-up",{
    name="Up",
    section="Destination",
    key=KEY_SPACE,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-down",{
    name="Down",
    section="Destination",
    key=KEY_LCONTROL,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-boost",{
    name="Boost",
    section="Destination",
    key=KEY_LSHIFT,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-slow",{
    name="Slow",
    section="Destination",
    key=KEY_LALT,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-rotate",{
    name="Rotate",
    section="Destination",
    key=KEY_LALT,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-demat",{
    name="Set",
    section="Teleport",
    func=function(self,down,ply)
        if ply:GetTardisData("destination") then
            local prop = self:GetData("destinationprop")
            if IsValid(prop) then
                self:SendMessage("destination-demat", {prop:GetPos(), prop:GetAngles()})
            end
        end
    end,
    key=MOUSE_LEFT,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-snaptofloor",{
    name="SnapToFloor",
    section="Destination",
    func=function(self,down,ply)
        if ply:GetTardisData("destination") then
            local prop = self:GetData("destinationprop")
            if IsValid(prop) then
                local pos = util.QuickTrace(prop:GetPos()+Vector(0,0,50), Vector(0,0,-1)*99999999).HitPos
                prop:SetPos(pos)
            end
        end
    end,
    key=KEY_R,
    clientonly=true,
    exterior=true
})

if SERVER then
    function ENT:SetDestination(pos, ang)
        if self:CallCommonHook("CanChangeDestination", pos, ang) == false then
            return false
        end

        if not isvector(pos) or not isangle(ang) then
            self:SetData("destination_pos",nil,true)
            self:SetData("destination_ang",nil,true)
            return false
        end
        self:SetData("destination_pos",pos,true)
        self:SetData("destination_ang",ang,true)
        self:CallCommonHook("DestinationChanged", pos, ang)
        return true
    end

    function ENT:SetDestinationPos(pos)
        return self:SetDestination(pos, self:GetData("destination_ang"))
    end

    function ENT:SetDestinationAng(ang)
        return self:SetDestination(self:GetData("destination_pos"), ang)
    end

    function ENT:SetRandomDestination(grounded)
        local randomLocation = self:GetRandomLocation(grounded)
        if randomLocation then
            self:CallHook("RandomDestinationSet", randomLocation)
            self:SetDestination(randomLocation, Angle(0,0,0))
            return true
        else
            return false
        end
    end

    function ENT:SelectDestination(ply, enabled)
        if IsValid(ply) and ply:IsPlayer() and self.occupants[ply] then
            if ply:GetTardisData("thirdperson") then
                -- bit hacky but allows us to take away pilot controls without taking them out third person
                ply:SetTardisData("thirdperson", false, true)
                self:CallHook("ThirdPerson", ply, false)
                ply:SetTardisData("wasthirdperson", true, true)
            end
            if enabled==false and ply:GetTardisData("wasthirdperson") then
                ply:SetTardisData("thirdperson", true, true)
                self:CallHook("ThirdPerson", ply, true)
                ply:SetTardisData("wasthirdperson", false, true)

                ply:SetTardisData("destination", false, true)
                self:CallHook("Destination", ply, false)
                self:SendMessage("destination", {false}, ply)
                return true
            elseif self:SetOutsideView(ply, enabled) then
                ply:SetTardisData("destination", enabled, true)
                self:CallHook("Destination", ply, enabled)
                self:SendMessage("destination", {enabled}, ply)
                return true
            end
        end
        return false
    end

    ENT:AddHook("Outside", "destination", function(self, ply, enabled)
        if not enabled then
            ply:SetTardisData("destination", enabled, true)
            self:CallHook("Destination", ply, enabled)
            self:SendMessage("destination", {enabled}, ply)
        end
    end)

    ENT:OnMessage("destination-demat", function(self, data, ply)
        if not self:CheckSecurity(ply) then
            TARDIS:Message(ply, "Security.ControlUseDenied")
            return
        end
        local pos = data[1]
        local ang = data[2]
        if ply:GetTardisData("destination") then
            self:SelectDestination(ply, false)
        end
        if self:GetData("vortex") or self:GetData("teleport") then
            if self:SetDestination(pos,ang) then
                TARDIS:Message(ply, "Destination.LockedReadyToMat")
            else
                TARDIS:ErrorMessage(ply, "Destination.FailedSetDestinationMaybeTransitioning")
            end
        else
            if TARDIS:GetSetting("dest-onsetdemat", ply) then
                self:Demat(pos,ang,function(success)
                    if success then
                        TARDIS:Message(ply, "Destination.LockedDemat")
                    else
                        TARDIS:ErrorMessage(ply, "Destination.FailedDemat")
                    end
                end)
            else
                if self:SetDestination(pos,ang) then
                    TARDIS:Message(ply, "Destination.LockedReadyToDemat")
                else
                    TARDIS:ErrorMessage(ply, "Destination.FailedSetDestination")
                end
            end
        end
    end)
else
    local defaultdist = 210
    function ENT:GetDestinationPropPos(ply, pos, ang)
        local prop = self:GetData("destinationprop")
        if not IsValid(prop) then return end
        local pos=prop:LocalToWorld(Vector(0,0,60))
        local tr = util.TraceLine({
            start=pos,
            endpos=pos-(ang:Forward()*ply:GetTardisData("destinationdist",defaultdist)),
            mask=MASK_NPCWORLDSTATIC,
            ignoreworld=self:GetData("vortex")
        })
        return tr.HitPos+(ang:Forward()*10), Angle(ang.p,ang.y,0)
    end

    local function setup(ent, model, pos, ang)
        if not IsValid(ent) then return end
        local prop = ents.CreateClientProp()

        prop:SetModel(model or ent:GetModel())
        prop:SetPos((pos and ent:LocalToWorld(pos)) or ent:GetPos())
        prop:SetAngles((ang and ent:LocalToWorldAngles(ang)) or ent:GetAngles())

        local col = prop:GetColor()
        prop:SetColor(Color(col.r, col.g, col.b, 100))
        prop:SetRenderMode(RENDERMODE_TRANSALPHA)
        prop:SetSkin(ent:GetSkin())
        prop:Spawn()
        local groups = ent:GetBodyGroups()
        if groups then
            for k,v in pairs(groups) do
                prop:SetBodygroup(v.id, v.num)
            end
        end
        return prop
    end

    function ENT:CreateDestinationProp()
        self:RemoveDestinationProp()

        local cham_ext = self:GetData("chameleon_selected_exterior")
        local md
        if cham_ext then
            md = TARDIS:CreateExteriorMetadata(cham_ext)
        end

        local prop = setup(self, (md and md.Model))

        if md and md.Portal and md.Parts and md.Parts["door"] then
            local d = md.Parts["door"]
            local portal = md.Portal

            local pos, ang = d.posoffset or Vector(0,0,0), d.angoffset or Angle(0,0,0)

            local portal_pos = portal.pos or Vector(0,0,0)
            local portal_ang = portal.ang or Angle(0,0,0)

            if d.use_exit_point_offset and portal.exit_point_offset then
                portal_pos = portal_pos + portal.exit_point_offset.pos
                portal_ang = portal_ang + portal.exit_point_offset.ang
            elseif d.use_exit_point_offset and portal.exit_point then
                portal_pos = portal.exit_point.pos
                portal_ang = portal.exit_point.ang
            end

            pos,ang=LocalToWorld(pos,ang,portal_pos,portal_ang)
            d.pos = pos
            d.ang = ang
        end

        for k,v in pairs(self.parts) do
            if not v.NoShadowCopy and (not md or (md.Parts and md.Parts[k]))
            then
                local attachment
                if md then
                    local p = md.Parts[k]
                    attachment = setup(v, p.model, p.pos, p.ang)
                else
                    attachment = setup(v)
                end

                if IsValid(attachment) then
                    attachment:SetParent(prop)
                end
            end
        end

        prop:SetAngles(Angle(0,0,0))

        self:SetData("destinationprop", prop)
    end

    function ENT:RemoveDestinationProp()
        local prop = self:GetData("destinationprop")
        if IsValid(prop) then
            for k,v in pairs(prop:GetChildren()) do
                if IsValid(v) then
                    v:Remove()
                end
            end
            prop:Remove()
        end
    end

    ENT:AddHook("Outside-StartCommand", "destination", function(self, ply, cmd)
        if LocalPlayer():GetTardisData("destination") and cmd:GetMouseWheel()~=0 then
            ply:SetTardisData("destinationdist",math.Clamp(ply:GetTardisData("destinationdist",defaultdist)-cmd:GetMouseWheel()*0.03*(1.1+ply:GetTardisData("destinationdist",defaultdist)),90,500))
        end
    end)

    ENT:AddHook("Outside-PosAng", "destination", function(self, ply, pos, ang)
        if LocalPlayer():GetTardisData("destination") then
            return self:GetDestinationPropPos(ply, pos, ang)
        end
    end)

    ENT:AddHook("Destination", "destination", function(self, enabled)
        if enabled then
            self:CreateDestinationProp()
        else
            self:RemoveDestinationProp()
        end
    end)

    ENT:OnMessage("destination", function(self, data, ply)
        local enabled = data[1]
        self:CallHook("Destination", enabled)
    end)

    ENT:AddHook("OnRemove", "destination", function(self)
        self:RemoveDestinationProp()
    end)

    ENT:AddHook("VortexEnabled", "destination", function(self)
        if LocalPlayer():GetTardisData("destination") then
            return false
        end
    end)

    ENT:AddHook("Think", "destination", function(self)
        if LocalPlayer():GetTardisData("destination") then
            local prop=self:GetData("destinationprop")
            if not IsValid(prop) then return end
            local dt=FrameTime()*66
            local eye=LocalPlayer():EyeAngles()
            eye.r = 0
            if not eye then
                eye=angle_zero
            end
            local force = 15
            local angforce = 6
            local boostmul = 15
            local slowmul = 0.1
            local angslowmul = 0.5
            local fwd=eye:Forward()
            local ri=eye:Right()
            local up=prop:GetUp()

            local mv = Vector(0,0,0)
            local rt = Angle(0,0,0)
            if TARDIS:IsBindDown("destination-forward") then
                mv:Add(force*fwd*dt)
            elseif TARDIS:IsBindDown("destination-backward") then
                mv:Add(force*fwd*-1*dt)
            end

            if TARDIS:IsBindDown("destination-rotate") and TARDIS:IsBindDown("destination-boost") then
                if TARDIS:IsBindDown("destination-left") then
                    rt = rt + Angle(0,angforce*dt,0)
                end
                if TARDIS:IsBindDown("destination-right") then
                    rt = rt + Angle(0,angforce*-1*dt,0)
                end
            else
                if TARDIS:IsBindDown("destination-left") then
                    mv:Add(force*ri*-1*dt)
                end
                if TARDIS:IsBindDown("destination-right") then
                    mv:Add(force*ri*dt)
                end
            end

            if TARDIS:IsBindDown("destination-up") then
                mv:Add(force*up*dt)
            elseif TARDIS:IsBindDown("destination-down") then
                mv:Add(force*up*-1*dt)
            end

            if TARDIS:IsBindDown("destination-slow") then
                mv=mv*slowmul
                rt=rt*angslowmul
            elseif TARDIS:IsBindDown("destination-boost") then
                mv=mv*boostmul
                rt=rt*boostmul
            end

            if not mv:IsZero() then
                prop:SetPos(prop:GetPos() + mv)
            end
            if not rt:IsZero() then
                prop:SetAngles(prop:GetAngles() + rt)
            end
        end
    end)
end

function ENT:GetDestination()
    return self:GetData("destination_pos"), self:GetData("destination_ang")
end

function ENT:GetDestinationPos(auto)
    return self:GetData("destination_pos") or (auto and self:GetPos() or nil)
end

function ENT:GetDestinationAng(auto)
    return self:GetData("destination_ang") or (auto and self:GetAngles() or nil)
end

function ENT:GetRandomLocation(grounded)
    local td = {}
    td.mins = self:OBBMins()
    td.maxs = self:OBBMaxs()
    local max = 16384
    local tries = 1000
    local point
    while tries > 0 do
        tries = tries - 1
        point=Vector(math.random(-max, max),math.random(-max, max),math.random(-max, max))
        td.start=point
        td.endpos=point
        if not util.TraceHull(td).Hit
        then
            if grounded then
                local down = util.QuickTrace(point + Vector(0, 0, 50), Vector(0, 0, -1) * 99999999).HitPos
                return down, true
            else
                return point, false
            end
        end
    end
end