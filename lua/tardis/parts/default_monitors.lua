local HIDE_COLLISIONS = true

local PART = {}
PART.Model = "models/molda/toyota_int/monitor.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.poses_flip = { 0.5, 1, 0.5, 0, }
PART.poses_down = { 0.5, 0, 1, }

PART.AnimateOptions = {
    Type = "custom",
    PoseParameter = "Bone",
    Speed = 0.3,
    CustomAnimationFunc = function(self, anim)
        local target = self:GetData(self.data_rotation,0)

        local to_target = math.abs(anim.pos - target)
        local through_min = anim.pos + math.abs(1 - target)
        local through_max = math.abs(1 - anim.pos) + target

        local min_path = math.min(to_target, through_min, through_max)

        if min_path == to_target then
            TARDIS.DoPartAnimation(self, true, anim, target, false)
        elseif min_path == through_min then
            TARDIS.DoPartAnimation(self, true, anim, 0, true)
        else
            TARDIS.DoPartAnimation(self, true, anim, 1, true)
        end
    end,
}

PART.ExtraAnimations = {
    {
        Type = "custom",
        PoseParameter = "arm",
        StartPos = 0.5,
        CustomAnimationFunc = function(self, anim)
            local target = self:GetData(self.data_down_pos, 0.5)
            TARDIS.DoPartAnimation(self, true, anim, target, false)
        end,
    },
    {
        Type = "custom",
        PoseParameter = "flip",
        StartPos = 0.5,
        CustomAnimationFunc = function(self, anim)
            local target = self:GetData(self.data_flip_pos, 0.5)
            TARDIS.DoPartAnimation(self, true, anim, target, false)
        end,
    },
}

function PART:Initialize(ply)
    self.data_flip = self.ID .. "_flip"
    self.data_flip_pos = self.ID .. "_flip_pos"
    self.data_down = self.ID .. "_down"
    self.data_down_pos = self.ID .. "_down_pos"

    self.data_rotation = self.ID .. "_rotation"
    self.data_rotated_by = self.ID .. "_rotated_by"

    self.handles_part_id = self.ID .. "_handles"
    self.collision_part_id = self.ID .. "_collision"

    self:SetBodygroup(0, 2)
end

local function trace_console_angle(int, ply)
    local origin = ply:EyePos()
    local aim = ply:GetAimVector()
    local delta = Vector(aim.x, aim.y, 0)

    local circle_pos = int:LocalToWorld(Vector(0,0,0))
    circle_pos.z = origin.z

    local r = 70

    local p1, p2 = util.IntersectRayWithSphere(origin, delta, circle_pos, 50)
    if not p1 then return nil end

    local point = int:WorldToLocal(origin + p1 * aim)
    if point.z < 140 or point.z > 165 then return nil end

    local d = point - Vector(0,0,point.z)
    local ang = d:Angle()

    return ang.y, point.z
end

local function select_monitor_pos(ply, part)
    local ang_y, down = trace_console_angle(part.interior, ply)
    if not ang_y then return end

    local rotation = math.Clamp((ang_y - part:GetAngles().y) % 360 / 360, 0, 1)
    local down = 1 - (down - 140) / 25

    return rotation, down
end

if SERVER then
    function PART:Use(ply)
        if ply:KeyDown(IN_WALK) then
            self:RotateToEyePos(ply)
        end
    end

    function PART:MoveDown()
        local down_state = self:GetData(self.data_down, 1) % #self.poses_down
        self:SetData(self.data_down, down_state + 1, true)
        self:SetData(self.data_down_pos, self.poses_down[down_state + 1], true)
        self:UpdateCollision()
    end

    function PART:Flip()
        local flip_state = self:GetData(self.data_flip, 1) % #self.poses_flip
        self:SetData(self.data_flip, flip_state + 1, true)
        self:SetData(self.data_flip_pos, self.poses_flip[flip_state + 1], true)
    end

    function PART:RotateToEyePos(ply)
        self:SetData(self.data_rotated_by, ply, true)
    end

    function PART:UpdateCollision()
        local handles_part = self.interior:GetPart(self.handles_part_id)
        local collision_part = self.interior:GetPart(self.collision_part_id)
        local yaw = self:GetData(self.data_rotation, 0)
        local down = self:GetData(self.data_down_pos, 0.5)

        if IsValid(handles_part) then
            handles_part:ApplyRotation(yaw)
            handles_part:ApplyVerticalPos(down)
        end

        if IsValid(collision_part) then
            collision_part:ApplyRotation(yaw)
            collision_part:ApplyVerticalPos(down)
        end
    end

    function PART:UpdatePosition(rotation, down)
        self:SetData(self.data_rotation, rotation, true)
        self:SetData(self.data_down_pos, down, true)
        self:UpdateCollision()
    end

    util.AddNetworkString("TARDIS_DefaultMonitorsRequestUpdate")

    function PART:Think()
        local ply = self:GetData(self.data_rotated_by)
        if not IsValid(ply) then return end

        if not ply:KeyDown(IN_USE) then
            self:RotateToEyePos(nil)
            local rotation, down = select_monitor_pos(ply, self)
            if rotation then
                self:UpdatePosition(rotation, down)
            else
                net.Start("TARDIS_DefaultMonitorsRequestUpdate")
                    net.WriteEntity(self)
                net.Send(ply)
            end
            return
        end
    end

    util.AddNetworkString("TARDIS_DefaultMonitorsUpdate")

    net.Receive("TARDIS_DefaultMonitorsUpdate", function(len,ply)
        local part = net.ReadEntity()
        local rotation, down = net.ReadFloat(), net.ReadFloat()

        if not rotation or not down then return end

        part:UpdatePosition(rotation, down)
    end)

    function PART:OnBodygroupChanged(bodygroup, value)
        local ring = self.interior:GetPart("default_rotor_ring")
        if not IsValid(ring) then return end

        if bodygroup == 0 and value == 0 then
            ring:SetBodygroup(0,0)
        else
            ring:SetBodygroup(0,1)
        end
    end
else
    function PART:UpdateServerPos()
        local rotation = self:GetData(self.data_rotation)
        local down = self:GetData(self.data_down_pos)
        if not rotation or not down then return end

        net.Start("TARDIS_DefaultMonitorsUpdate")
            net.WriteEntity(self)
            net.WriteFloat(rotation)
            net.WriteFloat(down)
        net.SendToServer()
    end

    net.Receive("TARDIS_DefaultMonitorsRequestUpdate", function(len,ply)
        local part = net.ReadEntity()
        if IsValid(part) then
            part:UpdateServerPos()
        end
    end)

    function PART:Think()
        local ply = self:GetData(self.data_rotated_by)
        if ply ~= LocalPlayer() then return end

        local rotation, down = select_monitor_pos(ply, self)

        if rotation then
            self:SetData(self.data_rotation, rotation)
            self:SetData(self.data_down_pos, down)
        end
    end
end

PART.ID = "default_monitor_1"
TARDIS:AddPart(PART)

PART.ID = "default_monitor_2"
TARDIS:AddPart(PART)



-- hitboxes

local PART = {}
PART.Model = "models/molda/toyota_int/hitboxes/monitor_handles.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.NoDraw = HIDE_COLLISIONS

function PART:Initialize()
    self.initial_pos = self:GetPos()
    self.initial_ang = self:GetAngles()

    if SERVER then
        self:ApplyVerticalPos(0.5)
    end
end

if SERVER then
    function PART:Use(ply)
        local monitor = self.interior:GetPart(self.MonitorID)
        if not IsValid(monitor) then return end

        if ply:KeyDown(IN_WALK) then
            monitor:Flip()
        else
            monitor:RotateToEyePos(ply)
        end
    end

    function PART:ApplyRotation(y)
        local yaw = y * 360
        local a = self:GetAngles()
        local a0 = self.initial_ang
        self:SetAngles(Angle(a.p, a0.y + yaw, a.r))
    end

    function PART:ApplyVerticalPos(k)
        local z = 0 - k * 8
        local roll = 0 + k * 2.4

        local p = self:GetPos()
        local a = self:GetAngles()
        local p0 = self.initial_pos
        local a0 = self.initial_ang
        self:SetPos(Vector(p.x, p.y, p0.z + z))
        self:SetAngles(Angle(a.p, a.y, a0.r + roll))
    end
end

PART.MonitorID = "default_monitor_1"
PART.ID = PART.MonitorID .. "_handles"
TARDIS:AddPart(PART)
PART.MonitorID = "default_monitor_2"
PART.ID = PART.MonitorID .. "_handles"
TARDIS:AddPart(PART)




local PART = {}
PART.Model = "models/molda/toyota_int/hitboxes/stage1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.NoDraw = HIDE_COLLISIONS

function PART:Initialize()
    self.initial_pos = self:GetPos()
    self.initial_ang = self:GetAngles()
    if SERVER then
        self:ApplyVerticalPos(0.5)
    end
end

if SERVER then
    function PART:Use(ply)
        local monitor = self.interior:GetPart(self.MonitorID)
        if not IsValid(monitor) then return end

        if ply:KeyDown(IN_WALK) then
            monitor:MoveDown()
        end
    end

    function PART:ApplyRotation(y)
        local yaw = y * 360
        local a = self:GetAngles()
        local a0 = self.initial_ang
        self:SetAngles(Angle(a.p, a0.y + yaw, a.r))
    end

    function PART:ApplyVerticalPos(k)
        local pr = "models/molda/toyota_int/hitboxes/"
        local model = "stage2.mdl"

        if k < 0.3 then
            model = "stage1.mdl"
        elseif k > 0.7 then
            model = "stage3.mdl"
        end

        self:SetModel(pr .. model)
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end

PART.MonitorID = "default_monitor_1"
PART.ID = PART.MonitorID .. "_collision"
TARDIS:AddPart(PART)

PART.MonitorID = "default_monitor_2"
PART.ID = PART.MonitorID .. "_collision"
TARDIS:AddPart(PART)


local PART={}
PART.ID = "default_rotor_ring"
PART.Model = "models/molda/toyota_int/rotor_ring.mdl"
PART.AutoSetup = true

function PART:Initialize()
    self:SetBodygroup(0,1)
end

TARDIS:AddPart(PART)