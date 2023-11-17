
local PART = {}
PART.Model = "models/molda/toyota_int/monitor.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

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

PART.poses_flip = { 0.5, 1, 0.5, 0, }
PART.poses_down = { 0.5, 0, 1, }

PART.ExtraAnimations = {
    {
        Type = "custom",
        PoseParameter = "arm",
        StartPos = 0.5,
        CustomAnimationFunc = function(self, anim)
            local pos = self:GetData(self.data_arm_pos)
            if pos then
                TARDIS.DoPartAnimation(self, true, anim, pos, false)
                return
            end

            local pose_no = self:GetData(self.data_down, 1)
            local target = self.poses_down[pose_no] or 0.5
            TARDIS.DoPartAnimation(self, true, anim, target, false)
        end,
    },
    {
        Type = "custom",
        PoseParameter = "flip",
        StartPos = 0.5,
        CustomAnimationFunc = function(self, anim)
            local pose_no = self:GetData(self.data_flip, 1)
            local target = self.poses_flip[pose_no] or 0.5
            TARDIS.DoPartAnimation(self, true, anim, target, false)
        end,
    },
}

function PART:Initialize(ply)
    self.data_flip = self.ID .. "_flip"
    self.data_down = self.ID .. "_down"
    self.data_rotation = self.ID .. "_rotation"
    self.data_rotated_by = self.ID .. "_rotated_by"
    self.data_rotate_start_yaw = self.ID .. "_rotate_start_yaw"
    self.handles_part_id = self.ID .. "_handles"
    self.handles_part = self.interior:GetPart(self.handles_part_id)
    self.data_arm_pos = self.ID .. "_arm_pos"
    self:SetData(self.data_flip, 0, true)
    self:SetData(self.data_down, 0, true)
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

if SERVER then
    function PART:Use(ply)
        self:SetData(self.ID .. "_rotated_by", ply, true)
    end

    function PART:MoveDown()
        local down_state = self:GetData(self.data_down,1) % #self.poses_down
        self:SetData(self.data_down, down_state + 1, true)
    end

    function PART:Flip()
        local flip_state = self:GetData(self.data_flip,1) % #self.poses_flip
        self:SetData(self.data_flip, flip_state + 1, true)
    end

    function PART:Think()
        local ply = self:GetData(self.data_rotated_by)
        if not IsValid(ply) then return end
        if not ply:KeyDown(IN_USE) then
            self:SetData(self.data_rotated_by, nil, true)
            return
        end

        local ang_y, z = trace_console_angle(self.interior, ply)
        if not ang_y then
            self:SetData(self.data_rotated_by, nil, true)
            return
        end

        local orig_angle = self:GetAngles().y

        local yaw_rel = (ang_y - orig_angle) % 360
        local yaw_pos = math.Clamp(yaw_rel / 360, 0, 1)

        self:SetData(self.data_rotation, yaw_pos, true)

        if not IsValid(self.handles_part) then
            self.handles_part = self.interior:GetPart(self.handles_part_id)
        end

        if IsValid(self.handles_part) then
            local curr = self.handles_part:GetAngles()
            local yaw = self.handles_part.initial_yaw + yaw_rel
            self.handles_part:SetAngles(Angle(curr.p, yaw, curr.r))
        end

        local z_pos = 1 - (z - 140) / 25
        self:SetData(self.data_arm_pos, z_pos, true)
    end
end

PART.ID = "default_monitor_1"
TARDIS:AddPart(PART)

PART.ID = "default_monitor_2"
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/molda/toyota_int/hitboxes/monitor_handles.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.MonitorID = "default_monitor_1"
PART.ID = PART.MonitorID .. "_handles"
PART.NoDraw = false

function PART:Initialize()
    self.initial_yaw = self:GetAngles().y
end

if SERVER then
    function PART:Use(ply)
        local monitor = self.interior:GetPart(self.MonitorID)
        if not IsValid(monitor) then return end

        if ply:KeyDown(IN_WALK) then
            monitor:Flip()
        else
            local yaw, z = trace_console_angle(self.interior, ply)
            self:SetData(self.MonitorID .. "_rotated_by", ply, true)
            --tardisdebug("A", yaw, self:GetAngles().y, self:GetAngles().y - self.initial_yaw)
            --tardisdebug("B", self:GetData(self.MonitorID .. "_rotation") * 360)
            --self:SetData(self.MonitorID .. "_rotate_start_yaw", yaw - self:GetAngles().y, true)
        end
    end
end


TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/molda/toyota_int/hitboxes/stage2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.MonitorID = "default_monitor_1"
PART.ID = PART.MonitorID .. "_collision"
PART.NoDraw = true

if SERVER then
    function PART:Use(ply)
        local monitor = self.interior:GetPart(self.MonitorID)
        if not IsValid(monitor) then return end

        if ply:KeyDown(IN_WALK) then
            monitor:MoveDown()
        end
    end
end

TARDIS:AddPart(PART)


--monitor_handles
--stage0
--stage1
--stage2
--stage3
--flip_stage1
--flip_stage2
--flip_stage3

--sonic_cube