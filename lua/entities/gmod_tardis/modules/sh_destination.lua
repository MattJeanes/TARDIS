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
TARDIS:AddKeyBind("destination-jump",{
    name="Jump",
    section="Destination",
    func=function(self,down,ply)
        if ply:GetTardisData("destination") then
            if down then
                self:SetData("destination-trace",true)
            elseif self:GetData("destination-trace") then
                local prop = self:GetData("destinationprop")
                local pos,ang = self:GetDestinationPropTrace(ply,ply:EyeAngles())
                --local pos,ang = self:GetDestinationPropTrace(ply,Angle(90,0,0))

                prop:SetPos(pos)
                prop:SetAngles(ang)

                self:SetData("destination-trace",false)
            end
        end
    end,
    key=MOUSE_RIGHT,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-snaptofloor",{
    name="SnapToFloor",
    section="Destination",
    func=function(self,down,ply)
        if down and ply:GetTardisData("destination") then
            local prop = self:GetData("destinationprop")
            if IsValid(prop) then
                local prevpos = self:GetData("destination_snaptofloor_lastpos")
                local should_glue = (prevpos == prop:GetPos())

                local pos, ang = self:GetGroundedPos(prop:GetPos(), should_glue)
                prop:SetPos(pos)
                prop:SetAngles(ang)
                self:SetData("destination_snaptofloor_lastpos", (not should_glue and pos))
            end
        end
    end,
    key=KEY_R,
    clientonly=true,
    exterior=true
})
TARDIS:AddKeyBind("destination-find-random",{
    name="FindRandom",
    section="Destination",
    func=function(self,down,ply)
        if down and ply:GetTardisData("destination") then
            local prop = self:GetData("destinationprop")
            prop:SetAngles(Angle(0,prop:GetAngles().y,0))
            if IsValid(prop) then
                local grounded = not self:GetData("destination_random_grounded")
                self:SetData("destination_random_grounded", grounded)
                local pos = self:GetRandomLocation(grounded)
                prop:SetPos(pos)
                self:SetData("destination_snaptofloor_lastpos", grounded and pos)
            end
        end
    end,
    key=KEY_F,
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
            return self:SetDestination(randomLocation, Angle(0,0,0))
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

    function ENT:GetDestinationPropTrace(ply,ang)
        local prop = self:GetData("destinationprop")
        local pos,ang=self:GetDestinationPropPos(ply,nil,ang)
        local trace=util.QuickTrace(pos,ang:Forward()*9999999999,{self,TARDIS:GetPart(self,"door"),prop})
        local angle=trace.HitNormal:Angle()
        angle:RotateAroundAxis(angle:Right(),-90)
        return trace.HitPos,angle
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
            local up=Vector(0,0,1)

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
                prop:SetAngles(Angle(0,prop:GetAngles().y,0) + rt)
            end
            if not rt:IsZero() then
                local ang = prop:GetAngles()
                local na = ang
                --na.p = na.p - 90
                local n = na:Up()

                ang:RotateAroundAxis(n, rt.y)
                prop:SetAngles(ang)
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

local TRACE_DISTANCE = 9999999999
local TRACE_DOWN_VECTOR = Vector(0, 0, -TRACE_DISTANCE)

local function TraceDown(point, vertical_offset)
    local vertical_offset = vertical_offset or 50
    return util.QuickTrace(point + Vector(0, 0, vertical_offset), TRACE_DOWN_VECTOR)
end

local function TraceDownHit(point, vertical_offset)
    return TraceDown(point, vertical_offset).HitPos
end

local function GenerateTracePoints(self, yaw)
    local trace_offsets = { Vector(0,0,0), }

    local xmin, ymin, zmin = self:OBBMins():Unpack()
    local xmax, ymax, zmax = self:OBBMaxs():Unpack()

    -- add points on the border rectangle

    table.insert(trace_offsets, Vector(xmin, ymin, zmin))
    table.insert(trace_offsets, Vector(xmax, ymax, zmin))
    table.insert(trace_offsets, Vector(xmin, ymax, zmin))
    table.insert(trace_offsets, Vector(xmax, ymin, zmin))

    table.insert(trace_offsets, Vector(xmin, 0.5 * ymin, zmin))
    table.insert(trace_offsets, Vector(xmin, 0.5 * ymax, zmin))
    table.insert(trace_offsets, Vector(xmax, 0.5 * ymin, zmin))
    table.insert(trace_offsets, Vector(xmax, 0.5 * ymax, zmin))
    table.insert(trace_offsets, Vector(0.5 * xmin, ymin, zmin))
    table.insert(trace_offsets, Vector(0.5 * xmax, ymin, zmin))
    table.insert(trace_offsets, Vector(0.5 * xmin, ymax, zmin))
    table.insert(trace_offsets, Vector(0.5 * xmax, ymax, zmin))

    for i,v in ipairs(trace_offsets) do
        v:Rotate(yaw)
    end

    local r = self:OBBMins() / math.sqrt(2)

    -- add points from a circle in the middle
    local num_dirs = 9
    for i = 0,num_dirs do
        r:Rotate(Angle(0,360 / num_dirs,0))
        table.insert(trace_offsets, (Vector() + r))
        table.insert(trace_offsets, (Vector() + r) * 0.75)
    end

    return trace_offsets
end

local function GetPlaneNormal(p1, p2, p3)
    local d1 = p1 - p2
    local d2 = p1 - p3

    local normal = d1:Cross(d2)
    if normal.z < 0 then normal = -normal end

    return normal:GetNormalized()
end

local function SelectPlaneDefiningPoints(points)
    local a,b = points[1], points[2]

    local todelete = {}
    for i,c in ipairs(points) do
        local ca = c - a
        local cb = c - b

        local ca_h = Vector(ca.x, ca.y, 0)
        local cb_h = Vector(cb.x, cb.y, 0)

        -- removing points on the same line as the first two selected
        if ca_h:Cross(cb_h):IsEqualTol(Vector(0,0,0), 0.01) then
            table.insert(todelete, i)
        end
    end
    table.sort(todelete, function(a,b) return a > b end)
    for i,c in ipairs(todelete) do
        table.remove(points, c)
    end

    -- select the third highest point
    local c = points[3]

    if not c then
        -- all the points were in one line
        -- this means we're probably landing horizontally
        return nil
    end

    return a,b,c
end

function ENT:GetGroundedPos(point, get_angle)
    --[[
    -- Debugging code, might be useful in the future
        RunConsoleCommand("tardis2_debug_pointer_clear")
    ]]

    local prop = self:GetData("destinationprop")
    local prop_yaw = Angle(0,prop:GetAngles().y,0)

    local traces = {}
    table.insert(traces, TraceDownHit(point))

    -- a number of point quick-traces is more precise than TraceEntityHull or TraceEntity since they don't take rotation into account

    for k,offset in ipairs(GenerateTracePoints(self,prop_yaw)) do
        table.insert(traces, TraceDownHit(point + offset))
    end

    -- finding top 3 points
    table.sort(traces, function(a, b) return a.z > b.z end)

    local pos = Vector(point.x, point.y, traces[1].z)

    if not get_angle then
        return pos, prop_yaw
    end

    local a,b,c = SelectPlaneDefiningPoints(traces)
    if a == nil then
        return pos, prop_yaw
    end

    local cur_normal = GetPlaneNormal(a,b,c)

    -- looking for the highest selected plane with the first two points
    for j,c2 in ipairs(traces) do
        local n = GetPlaneNormal(a, b, c2)
        if n.z > cur_normal.z then
            c = c2
            cur_normal = n
        end
    end

    local ca = c - a
    local cb = c - b

    --[[
    -- Debugging code, might be useful in the future
    for k,v in ipairs(traces) do
        if not v:IsEqualTol(a, 0.0001) and not v:IsEqualTol(b, 0.0001) and not v:IsEqualTol(c, 0.0001) then
            RunConsoleCommand("tardis2_debug_pointer", "worldpos", v.x, v.y, v.z)
        end
    end
    RunConsoleCommand("tardis2_debug_pointer_color")
    RunConsoleCommand("tardis2_debug_pointer", "worldpos", a.x, a.y, a.z)
    RunConsoleCommand("tardis2_debug_pointer", "worldpos", b.x, b.y, b.z)
    RunConsoleCommand("tardis2_debug_pointer", "worldpos", c.x, c.y, c.z)
    ]]

    local normal = ca:Cross(cb):GetNormalized()

    if normal.z < 0 then
        -- looking down
        normal = - normal
    end

    local ang = normal:Angle() + Angle(90,0,0)
    ang:RotateAroundAxis(normal, prop_yaw.y)

    if normal ~= Vector(0,0,0) and normal.z > 0.5 then
        -- the TARDIS can land there and the selected position is not vertical

        local A,B,C = normal:Unpack()
        local x0,y0,z0 = a:Unpack()

        local D = - A * x0 - B * y0 - C * z0
        local z = (- D - A * point.x - B * point.y) / C

        return Vector(point.x, point.y, z), ang
    end

    return pos, Angle(0,prop_yaw.y,0)
end

function ENT:CanFit(point)
    return not util.TraceEntity({start = point, endpos = point}, self).Hit
end

local function IsTraceBelowWorld(trace_result)
    if trace_result.HitPos.z < -16384 then
        return true
    end
    local texture = trace_result.HitTexture
    if texture == "**empty**"
        or texture == "TOOLS/TOOLSNODRAW"
        or texture == "TOOLS/TOOLSSKYBOX"
    then
        return true
    end
    return false
end

function ENT:FindPosInBox(p1, p2)
    local xmin, ymin, zmin = p1:Unpack()
    local xmax, ymax, zmax = p2:Unpack()

    local tries = 1000
    local point

    if xmin > xmax or ymin > ymax or zmin > zmax then
        return
    end

    while tries > 0 do
        tries = tries - 1

        local x = (xmin == xmax) and xmin or math.Rand(xmin, xmax)
        local y = (ymin == ymax) and ymin or math.Rand(ymin, ymax)
        local z = (zmin == zmax) and zmin or math.Rand(zmin, zmax)

        point=Vector(x,y,z)

        if self:CanFit(point) and not IsTraceBelowWorld(TraceDown(point, -50)) then
            return point
        end
    end
end

function ENT:GetRandomLocation(grounded)
    local max = 16384

    local pos = self:FindPosInBox(Vector(-max,-max,-max), Vector(max,max,max))

    if not pos then
        return self:GetPos()
    elseif not grounded then
        return pos
    end

    pos = self:GetGroundedPos(pos)

    if math.random(0,5) == 0 then
        return pos
    end

    -- Searching for underground / indoor locations
    -- the probability of them is rather low, but much higher than after the initial search
    -- plus, the chances of skybox landing are lower

    local locations = {}

    local trace_res, trace_good, trace_last_hitpos

    local function trace_down_next()
        trace_res = TraceDown(trace_last_hitpos, -50)
        trace_last_hitpos = trace_res.HitPos
        trace_good = not IsTraceBelowWorld(trace_res)
    end

    trace_last_hitpos = pos
    trace_down_next()
    while trace_good do
        table.insert(locations, trace_last_hitpos)
        trace_down_next()
    end

    if #locations < 1 then return pos end

    local newpos = locations[math.random(#locations)]
    local z_size = self:OBBMaxs().z - self:OBBMins().z + 50

    -- we gotta make sure the TARDIS fits
    newpos = self:FindPosInBox(Vector(pos.x,pos.y,newpos.z - z_size), Vector(pos.x,pos.y,newpos.z + z_size))

    if newpos then
        pos = self:GetGroundedPos(newpos)
    end

    return pos
end