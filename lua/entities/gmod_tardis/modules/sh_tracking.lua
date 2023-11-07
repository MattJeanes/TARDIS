-- Tracking

local TRACKING_MAX_DISTANCE_SET = 1000
local TRACKING_MAX_DISTANCE_TARGET_MAX = 1500
local TRACKING_MAX_DISTANCE_NO_LOS = 2000
local TRACKING_MAX_DISTANCE_TRACE = 10000

local TRACKING_DEBUG = false

TARDIS:AddKeyBind("tracking",{
    name="Tracking",
    section="Flight",
    func=function(self,down,ply)
        local pilot = self:GetData("pilot")
        if down and self:CallHook("CanTrack") == false then return end
        if ply==pilot then
            if down then
                self:SetData("tracking-trace",true)
            else
                self:SendMessage("tracking-set", {self:GetData("tracking-ent")})
            end
        end
        if not down then
            self:SetData("tracking-trace",false)
            self:SetData("tracking-ent",nil)
        end
    end,
    key=KEY_X,
    clientonly=true,
    exterior=true
})

TARDIS:AddKeyBind("tracking-rotation",{
    name="TrackRotation",
    section="Flight",
    func=function(self,down,ply)
        local pilot = self:GetData("pilot")
        if not self:GetTracking() or ply ~= pilot or not down then return end
        self:ToggleTrackRotation()
        TARDIS:StatusMessage(ply, "Controls.Tracking.Rotation", self:GetTrackRotation())
    end,
    key=KEY_T,
    serveronly=true,
    exterior=true
})

if SERVER then
    function ENT:GetTracking()
        return self:GetData("tracking-ent")
    end

    function ENT:SetTracking(ent, ply)
        if not ply then ply = self:GetData("pilot") end
        local wasTrackingEnt = self:GetData("tracking-ent")
        local wasTracking = IsValid(wasTrackingEnt)
        local isTracking = IsValid(ent)
        local valid = true
        if isTracking then 
            if ent.TardisPart or ent.TardisInterior or (ent:IsPlayer() and IsValid(TARDIS:GetInteriorEnt(ent))) then
                if IsValid(ply) then
                    TARDIS:ErrorMessage(ply, "Controls.Tracking.InteriorFail")
                end
                valid = false
            elseif ent == self then
                if IsValid(ply) then
                    TARDIS:ErrorMessage(ply, "Controls.Tracking.SelfFail")
                end
                valid = false
            elseif ent:GetPos():Distance(self:GetPos()) > TRACKING_MAX_DISTANCE_SET then
                if IsValid(ply) then
                    TARDIS:ErrorMessage(ply, "Controls.Tracking.DistanceFail")
                end
                valid = false
            elseif self:CallHook("CanTrack", ent, ply) == false then
                if IsValid(ply) then
                    TARDIS:ErrorMessage(ply, "Controls.Tracking.GenericFail")
                end
                valid = false
            end
            if not valid then
                return false
            end

            local wasFlying = self:GetFlight()
            if not wasFlying then
                local success = self:SetFlight(true)
                if not success then
                    if IsValid(ply) then
                        TARDIS:ErrorMessage(ply, "Controls.Tracking.FlightFail")
                    end
                    return false
                end
            end

            if not wasTracking then
                self:SetData("tracking-wasflight", wasFlying)
            end
        end
        
        self:SetData("tracking-ent",ent)
        if IsValid(ent) and ent ~= wasTrackingEnt then
            local offsetPos
            local offsetYaw
            if self:GetTrackRotation() then
                offsetPos = ent:WorldToLocal(self:GetPos())
                offsetYaw = -ent:GetAngles().y + self:GetAngles().y
            else
                offsetPos = WorldToLocal(self:GetPos(), angle_zero, ent:GetPos(), angle_zero)
                offsetYaw = self:GetAngles().y
            end
            self:SetData("tracking-offset-pos", offsetPos)
            self:SetData("tracking-offset-yaw", offsetYaw)
        end

        if not isTracking then
            if wasTracking and (not self:GetData("tracking-wasflight")) then
                self:SetFlight(false)
            end
            self:SetData("tracking-wasflight", nil)
            self:SetData("tracking-offset-pos", nil)
            self:SetData("tracking-offset-yaw", nil)
            if IsValid(self.trackingdebugprop) then
                self.trackingdebugprop:Remove()
            end
        end

        if IsValid(ply) then
            if wasTracking ~= isTracking then
                TARDIS:StatusMessage(ply, "Controls.Tracking.Status", IsValid(ent))
            end
            if isTracking then
                if wasTrackingEnt ~= ent then
                    local name = ent.PrintName or (isfunction(ent.Name) and ent:Name()) or ent.Name or ent:GetModel() or ent:GetClass()
                    if ent.GetCreator then
                        local creator = ent:GetCreator()
                        if IsValid(creator) then
                            name = name .. " (" .. creator:Nick() .. ")"
                        end
                    end
                    TARDIS:Message(ply, "%s %s", "Controls.Tracking.Target", name)
                else 
                    TARDIS:Message(ply, "Controls.Tracking.SameTarget")
                end
            end
        end
        return true
    end

    function ENT:GetTrackRotation()
        return self:GetData("tracking-rotation", false)
    end

    function ENT:SetTrackRotation(on)
        self:SetData("tracking-rotation", on)

        local ent = self:GetTracking()
        if not IsValid(ent) then return end
        local offsetPos = self:GetData("tracking-offset-pos", Vector(0,0,0))
        local offsetYaw = self:GetData("tracking-offset-yaw", 0)
        local newOffsetPos, newOffsetYaw
        if on then
            local currentTrackingPos = ent:GetPos() + offsetPos
            newOffsetPos = ent:WorldToLocal(currentTrackingPos)
            newOffsetYaw = offsetYaw - ent:GetAngles().y
        else
            local currentTrackingPos = ent:LocalToWorld(offsetPos)
            newOffsetPos = WorldToLocal(currentTrackingPos, angle_zero, ent:GetPos(), angle_zero)
            newOffsetYaw = offsetYaw + ent:GetAngles().y
        end
        self:SetData("tracking-offset-pos", newOffsetPos)
        self:SetData("tracking-offset-yaw", newOffsetYaw)
    end

    function ENT:ToggleTrackRotation()
        self:SetTrackRotation(not self:GetTrackRotation())
    end

    ENT:AddHook("Initialize", "tracking", function(self)
        self:SetTrackRotation(true)
    end)

    ENT:AddHook("HandleE2", "tracking", function(self, name, e2, ...)
        local args = {...}
        if name == "Track" and (args[1] == e2.player or TARDIS:CheckPP(e2.player, self)) then
            local ent = args[1]
            local success = self:SetTracking(ent, e2.player)
            return success and 1 or 0
        end
    end)

    ENT:AddHook("HandleE2", "tracking_get", function(self, name, e2)
        if name == "GetTracking" then
            return self:GetTracking() or NULL
        end
    end)

    ENT:AddHook("FlightToggled", "tracking", function(self, on)
        if not on then
            self:SetTracking()
        end
    end)

    ENT:AddHook("PhyslockToggled", "tracking", function(self, on)
        if on then
            self:SetTracking()
        end
    end)

    local VECTOR_0_0_1 = Vector(0,0,1)

    ENT:AddHook("PhysicsUpdate", "tracking", function(self, ph)
        local ent = self:GetTracking()
        if ent and not IsValid(ent) then
            self:SetTracking()
            return
        elseif not ent then
            return
        end

        local pos = self:GetPos()
        local entPos = ent:GetPos()
        local offset = self:GetData("tracking-offset-pos", Vector(0,0,0))
        local yawoffset = self:GetData("tracking-offset-yaw", 0)
        local pilot = self:GetData("pilot")
        local phm = FrameTime()*66
        local offsetforce = 5
        local offsetrforce = 2
        local spin = self:GetSpin()
        local trackrotation = self:GetTrackRotation()

        if IsValid(pilot) then
            local eye = pilot:GetTardisData("viewang")
            if not eye then
                eye = angle_zero
            end
            local fwd = eye:Forward()
            local ri = eye:Right()

            local fbinds = {
                forward = TARDIS:IsBindDown(pilot,"flight-forward"),
                backward = TARDIS:IsBindDown(pilot,"flight-backward"),
                left = TARDIS:IsBindDown(pilot,"flight-left"),
                right = TARDIS:IsBindDown(pilot,"flight-right"),
                rotate = TARDIS:IsBindDown(pilot,"flight-rotate"),
                up = TARDIS:IsBindDown(pilot,"flight-up"),
                down = TARDIS:IsBindDown(pilot,"flight-down"),
                boost = TARDIS:IsBindDown(pilot,"flight-boost"),
            }

            if fbinds.boost then
                offsetforce = offsetforce*TARDIS:GetSetting("boost-speed")
                offsetrforce = offsetrforce*TARDIS:GetSetting("boost-speed")
            end

            local adjustedOffset = Vector()
            if fbinds.forward then
                adjustedOffset:Add(fwd * offsetforce)
            end
            if fbinds.backward then
                adjustedOffset:Add(fwd * -offsetforce)
            end

            local adjustedYawOffset = yawoffset
            if fbinds.left then
                if fbinds.rotate then
                    if not spin then
                        adjustedYawOffset = adjustedYawOffset + offsetrforce
                        if adjustedYawOffset > 180 then
                            adjustedYawOffset = adjustedYawOffset - 360
                        end
                    end
                else
                    adjustedOffset:Add(ri * -offsetforce)
                end
            end
            if fbinds.right then
                if fbinds.rotate then
                    if not spin then
                        adjustedYawOffset = adjustedYawOffset - offsetrforce
                        if adjustedYawOffset < -180 then
                            adjustedYawOffset = adjustedYawOffset + 360
                        end
                    end
                else
                    adjustedOffset:Add(ri * offsetforce)
                end
            end

            local spinwarning = (fbinds.left or fbinds.right) and fbinds.rotate and spin
            if spinwarning and self:GetData("lastspinwarning", 0) < CurTime() then
                self:SetData("lastspinwarning", CurTime() + 1)
                TARDIS:Message(pilot, "Controls.Tracking.SpinWarning")
            end

            if fbinds.up then
                adjustedOffset:Add(Vector(0,0,offsetforce))
            elseif fbinds.down then
                adjustedOffset:Add(Vector(0,0,-offsetforce))
            end

            if adjustedOffset ~= vector_origin then
                adjustedOffset:Mul(phm)
                if trackrotation then
                    offset:Add(WorldToLocal(adjustedOffset, angle_zero, vector_origin, ent:GetAngles()))
                else
                    offset:Add(adjustedOffset)
                end
                self:SetData("tracking-offset-pos", offset)
            end

            if adjustedYawOffset ~= yawoffset then
                yawoffset = adjustedYawOffset
                self:SetData("tracking-offset-yaw", yawoffset)
            end
        end

        local tvel = ent:GetVelocity()
        local tfwd = tvel:Angle():Forward()
        local target
        if trackrotation then
            target = ent:LocalToWorld(offset)
        else
            target = entPos + offset
        end
        local offsetdist = entPos:Distance(target)
        local tdiff = target:Distance(pos)
        local targetpredicted = target+(tfwd*tvel:Length()*phm)
        local mass = ph:GetMass()
        local vel = ph:GetVelocity()
        local velnorm = vel:GetNormalized()
        local len = vel:Length()

        if offsetdist > TRACKING_MAX_DISTANCE_TARGET_MAX then
            self:SetTracking()
            if IsValid(pilot) then
                TARDIS:ErrorMessage(pilot, "Controls.Tracking.TargetTooFar")
            end
            return
        end

        local targetph = ent:GetPhysicsObject()
        if trackrotation and IsValid(targetph) then
            local tdifftoent = (target-entPos):Angle()
            local tdifftoentfwd = tdifftoent:Forward()
            tdifftoentfwd.z = 0
            local spinvelocity = math.abs(targetph:GetAngleVelocity():Dot(VECTOR_0_0_1))
            local angveloutwards = (tdifftoentfwd * spinvelocity * 2 * phm)
            targetpredicted = targetpredicted + angveloutwards
        end

        if tdiff > TRACKING_MAX_DISTANCE_TRACE then
            self:SetTracking()
            if IsValid(pilot) then
                TARDIS:ErrorMessage(pilot, "Controls.Tracking.TargetLost")
            end
            return
        end

        local diffang = (entPos - pos):Angle()
        local trace = util.QuickTrace(pos,diffang:Forward()*TRACKING_MAX_DISTANCE_TRACE,{self,TARDIS:GetPart(self,"door")})
        local targetfound = trace.Entity==ent or tdiff < TRACKING_MAX_DISTANCE_NO_LOS

        local trackinglost = self:GetData("tracking-lost")
        if trackinglost and CurTime() > trackinglost then
            self:SetData("tracking-lost", nil)
            self:SetTracking()
            if IsValid(pilot) then
                TARDIS:ErrorMessage(pilot, "Controls.Tracking.TargetLost")
            end
            return
        elseif (not targetfound) and (not trackinglost) then
            self:SetData("tracking-lost", CurTime() + 5)
        elseif targetfound and trackinglost then
            self:SetData("tracking-lost", nil)
        end

        if TRACKING_DEBUG then
            if not IsValid(self.trackingdebugprop) then
                self.trackingdebugprop = ents.Create("prop_physics")
                self.trackingdebugprop:SetModel("models/hunter/blocks/cube05x05x05.mdl")
                self.trackingdebugprop:SetColor(Color(255,0,0))
                self.trackingdebugprop:SetRenderMode(RENDERMODE_TRANSALPHA)
                self.trackingdebugprop:SetMoveType(MOVETYPE_NONE)
                self.trackingdebugprop:SetSolid(SOLID_NONE)
                self.trackingdebugprop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                self.trackingdebugprop:Activate()
                self.trackingdebugprop:Spawn()
            end

            self.trackingdebugprop:SetPos(targetpredicted)
        end

        local tpdiff = targetpredicted-pos
        local tdist = tpdiff:Length()
        local diffnorm = tpdiff:GetNormalized()
        local force = math.Clamp((tdist * 0.05), 0, 15*TARDIS:GetSetting("boost-speed"))

        ph:AddVelocity(diffnorm*force*phm)

        local brake = len-tdist
        local brakeClamped = math.Clamp(brake, 0, len)*0.9
        ph:AddVelocity(velnorm*-brakeClamped)

        if not spin then
            local cen = ph:GetMassCenter()
            local fwd = self:GetForward()
            local lev = ph:GetInertia():Length()
            local ri = self:GetRight()
            local ang = self:GetAngles()

            local targetang = yawoffset
            if trackrotation then
                targetang = targetang + ent:GetAngles().y
            end
            local angdiff = math.AngleDifference(targetang,ang.y)
            ph:AddAngleVelocity(Vector(0,0,angdiff*phm))
            ph:AddAngleVelocity(Vector(0,0,ph:GetAngleVelocity().z*-0.3*phm))

            if TRACKING_DEBUG then
                self.trackingdebugprop:SetAngles(Angle(0,targetang,0))
            end
        end
    end)

    ENT:AddHook("OnRemove", "tracking", function(self)
        if IsValid(self.trackingdebugprop) then
            self.trackingdebugprop:Remove()
        end
    end)

    ENT:AddHook("FlightControl", "tracking", function(self, ply)
        if self:GetTracking() then
            return false
        end
    end)

    ENT:AddHook("StopDemat", "tracking", function(self)
        if self:GetTracking() then
            self:SetTracking()
        end
    end)

    ENT:AddHook("PilotChanged", "tracking", function(self, old, new)
        if IsValid(new) and self:GetTracking() then
            self:SendMessage("tracking-pilotwarning", nil, new)
        end
    end)

    ENT:AddHook("ShouldTeleportPortal", "tracking", function(self,portal,ent)
        local trackingEnt = self:GetTracking()
        if not IsValid(trackingEnt) then return end

        if ent == trackingEnt then
            return false
        end
        if table.HasValue(constraint.GetAllConstrainedEntities(trackingEnt), ent) then
            return false
        end
    end)

    ENT:OnMessage("tracking-set", function(self,data,ply)
        local ent = data[1]

        if self:GetData("pilot") ~= ply then return end
        
        self:SetTracking(ent)
    end)
else
    hook.Add("PostDrawTranslucentRenderables", "tardis-tracking", function()
        local ext = TARDIS:GetExteriorEnt()
        if not IsValid(ext) then return end
    
        if not ext:GetData("tracking-trace") then return end
    
        local pos,ang,ent = ext:GetThirdPersonTrace(LocalPlayer(),LocalPlayer():EyeAngles())
    
        local fw = ang:Forward()
        local bk = fw*-1
        local ri = ang:Right()
        local le = ri*-1
    
        ext:SetData("tracking-ent",ent)
        if not IsValid(ent) then
            local size = 10
            local col = Color(255,0,0)
            render.DrawLine(pos,pos+(fw*size),col)
            render.DrawLine(pos,pos+(bk*size),col)
            render.DrawLine(pos,pos+(ri*size),col)
            render.DrawLine(pos,pos+(le*size),col)
        end
    end)

    hook.Add("PreDrawHalos", "tardis-tracking", function()
        local ext = TARDIS:GetExteriorEnt()
        if not IsValid(ext) then return end
    
        local ent = ext:GetData("tracking-ent")
        if not IsValid(ent) then return end
    
        local dist = ent:GetPos():Distance(ext:GetPos())
        halo.Add({ent},dist > TRACKING_MAX_DISTANCE_SET and Color(255,0,0) or Color(0,255,0),1,1,1,true,true)
    end)

    ENT:OnMessage("tracking-pilotwarning", function(self)
        local keyName = input.GetKeyName(TARDIS:GetBindKey("tracking"))
        TARDIS:Message(LocalPlayer(), "Controls.Tracking.PilotWarning", string.upper(keyName))
    end)
end