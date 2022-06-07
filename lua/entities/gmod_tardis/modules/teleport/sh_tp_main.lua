-- Main teleport-related functions

TARDIS:AddKeyBind("teleport-demat",{
    name="Demat",
    section="Teleport",
    func=function(self,down,ply)
        if TARDIS:HUDScreenOpen(ply) then return end
        local pilot = self:GetData("pilot")
        if SERVER then
            if ply==pilot and down then
                ply:SetTardisData("teleport-demat-bind-down", true)
            end
            if ply==pilot and (not down) and ply:GetTardisData("teleport-demat-bind-down",false) then
                if not self:GetData("vortex") then
                    if self:GetData("demat-pos") then
                        self:Demat()
                        return
                    end
                    local pos,ang=self:GetThirdPersonTrace(ply,ply:GetTardisData("viewang"))
                    self:Demat(pos,ang)
                end
            end
            if not down and ply:GetTardisData("teleport-demat-bind-down",false) then
                ply:SetTardisData("teleport-demat-bind-down", nil)
            end
        else
            if ply==pilot and down and (not (self:GetData("vortex") or self:GetData("teleport"))) then
                self:SetData("teleport-trace",true)
            else
                self:SetData("teleport-trace",false)
            end
        end
    end,
    key=MOUSE_LEFT,
    exterior=true
})

TARDIS:AddKeyBind("teleport-mat",{
    name="Mat",
    section="Teleport",
    func=function(self,down,ply)
        if TARDIS:HUDScreenOpen(ply) then return end
        if ply==self.pilot and down then
            if self:GetData("vortex") then
                self:Mat()
            end
        end
    end,
    serveronly=true,
    key=MOUSE_LEFT,
    exterior=true
})

if SERVER then

    function ENT:SetDestination(pos, ang)
        self:SetData("demat-pos",pos,true)
        self:SetData("demat-ang",ang,true)
        return true
    end

    function ENT:SetRandomDestination(grounded)
        local pos = self:GetRandomLocation(grounded)
        local ang = Angle(0,0,0)
        self:SetDestination(pos, ang)
    end

    function ENT:GetDestination()
        return self:GetData("demat-pos"), self:GetData("demat-ang")
    end

    function ENT:ForceDematState()
        self:SetDestination(self:GetPos(), self:GetAngles())

        self:SetData("demat",true)
        self:SetData("vortexalpha", 1)
        self:SetData("teleport",true)
        self:SetData("alpha", 0)

        self:SetBodygroup(1,0)
        self:DrawShadow(false)
        for k,v in pairs(self.parts) do
            v:DrawShadow(false)
        end

        self:StopDemat()
    end

    function ENT:DematDoorCheck(force, callback)
        local autoclose = TARDIS:GetSetting("teleport-door-autoclose", self)
        if (force or autoclose) and self:GetData("doorstatereal") then
            self:CloseDoor()
        end
        if self:GetData("doorstatereal") then
            if callback then callback(false) end
            return false
        end
        return true
    end

    function ENT:Demat(pos, ang, callback, force)
        local ignore_failed_demat = self:GetData("redecorate")

        if self:CallHook("CanDemat", force, ignore_failed_demat) == false then
            self:HandleNoDemat(pos, ang, callback, force)
            return
        end

        if not self:DematDoorCheck(force, callback) then return end

        if force then
            self:SetData("force-demat", true, true)
            self:SetData("force-demat-time", CurTime(), true)
            self:Explode(30)
            self.interior:Explode(20)
        end

        pos=pos or self:GetData("demat-pos") or self:GetPos()
        ang=ang or self:GetData("demat-ang") or self:GetAngles()
        self:SetBodygroup(1,0)
        self:SetDestination(pos, ang)
        self:SendMessage("demat", function() net.WriteVector(self:GetData("demat-pos",Vector())) end)
        self:SetData("demat",true)
        self:SetData("fastreturn-pos",self:GetPos())
        self:SetData("fastreturn-ang",self:GetAngles())
        self:SetData("step",1)
        self:SetData("teleport",true)
        self:SetCollisionGroup( COLLISION_GROUP_WORLD )

        self:CallHook("DematStart")
        if force then self:CallHook("ForceDematStart") end

        self:DrawShadow(false)
        for k,v in pairs(self.parts) do
            v:DrawShadow(false)
        end
        local constrained = constraint.GetAllConstrainedEntities(self)
        local attached
        if constrained then
            for k,v in pairs(constrained) do
                if not (k.TardisPart or k==self) then
                    local a=k:GetColor().a
                    if not attached then attached = {} end
                    attached[k] = a
                end
            end
        end
        self:SetData("demat-attached",attached,true)
        if callback then callback(true) end
    end

    function ENT:ChangePosition(pos, ang, phys_enable)
        local attached=self:GetData("demat-attached")
        if attached then
            for k,v in pairs(attached) do
                if IsValid(k) and not IsValid(k:GetParent()) then
                    k.telepos=k:GetPos()-self:GetPos()
                    if k:GetClass()=="gmod_hoverball" then -- fixes hoverballs spazzing out
                        k:SetTargetZ( (pos-self:GetPos()).z+k:GetTargetZ() )
                    end
                end
            end
        end
        self:SetPos(pos)
        self:SetAngles(ang)
        if attached then
            for k,v in pairs(attached) do
                if IsValid(k) and not IsValid(k:GetParent()) then
                    if k:IsRagdoll() then
                        for i=0,k:GetPhysicsObjectCount() do
                            local bone=k:GetPhysicsObjectNum(i)
                            if IsValid(bone) then
                                bone:SetPos(self:GetPos()+k.telepos)
                            end
                        end
                    end
                    k:SetPos(self:GetPos()+k.telepos)
                    k.telepos=nil
                    if phys_enable == true then
                        local phys=k:GetPhysicsObject()
                        if phys and IsValid(phys) then
                            k:SetSolid(SOLID_VPHYSICS)
                            if k.gravity~=nil then
                                phys:EnableGravity(k.gravity)
                                k.gravity = nil                               
                            end
                        end
                        k.nocollide=nil
                    end
                end
            end
        end
    end


    function ENT:Mat(callback)
        local pos = self:GetData("demat-pos", self:GetPos())
        local ang = self:GetData("demat-ang", self:GetAngles())

        if self:CallHook("CanMat", pos, ang) == false then
            self:HandleNoMat(pos, ang, callback)
            return
        end
        self:CloseDoor(function(state)
            if state then
                if callback then callback(false) end
                return
            end

            self:SendMessage("premat",function() net.WriteVector(self:GetData("demat-pos",Vector())) end)
            self:SetData("teleport",true)

            local timerdelay = (self:GetData("demat-fast",false) and 1.9 or 8.5)
            self:Timer("matdelay", timerdelay, function()
                if not IsValid(self) then return end
                self:SendMessage("mat")
                self:SetData("mat",true)
                self:SetData("step",1)
                self:SetData("vortex",false)
                local flight=self:GetData("prevortex-flight")
                if self:GetData("flight")~=flight then
                    self:SetFlight(flight)
                end
                self:SetData("prevortex-flight",nil)
                self:SetSolid(SOLID_VPHYSICS)
                self:CallHook("MatStart")
                self:ChangePosition(pos, ang, true)
                self:SetDestination(nil, nil)
            end)
            if callback then callback(true) end
        end)
    end

    function ENT:StopDemat()
        self:SetData("demat",false)
        self:SetData("force-demat", false, true)
        self:SetData("step",1)
        self:SetData("vortex",true)
        self:SetData("teleport",false)
        self:SetSolid(SOLID_NONE)
        self:RemoveAllDecals()

        local flight = self:GetData("flight")
        self:SetData("prevortex-flight",flight)
        if not flight then
            self:SetFlight(true)
        end
        local attached=self:GetData("demat-attached")
        if attached then
            for k,v in pairs(attached) do
                if IsValid(k) and not IsValid(k:GetParent()) then
                    local phys=k:GetPhysicsObject()
                    if phys and IsValid(phys) then
                        k:SetSolid(SOLID_NONE)
                        k.gravity = phys:IsGravityEnabled()
                        phys:EnableGravity(false)
                    end
                end
            end
        end
        self:CallHook("StopDemat")
    end

    function ENT:StopMat()
        self:SetBodygroup(1,1)
        self:SetData("mat",false)
        self:SetData("step",1)
        self:SetData("teleport",false)
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
        self:DrawShadow(true)
        for k,v in pairs(self.parts) do
            if not v.NoShadow then
                v:DrawShadow(true)
            end
        end
        local attached=self:GetData("demat-attached")
        if attached then
            for k,v in pairs(attached) do
                if IsValid(k) then
                    k:SetColor(ColorAlpha(k:GetColor(),v))
                end
            end
        end
        self:SetData("demat-attached",nil,true)
        if self:GetData("fastreturn",false) then
            self:SetFastRemat(self:GetData("demat-fast-prev", false))
            self:SetData("fastreturn",false)
        end
        self:CallHook("StopMat")
    end

    ENT:AddHook("CanDemat", "teleport", function(self, force, ignore_fail_demat)
        if self:GetData("teleport") or self:GetData("vortex") or (not self:GetPower())
        then
            return false
        end
    end)

    ENT:AddHook("CanMat", "teleport", function(self, dest_pos, dest_ang, ignore_fail_mat)
        if self:GetData("teleport") or (not self:GetData("vortex")) then
            return false
        end
    end)

    ENT:AddHook("StopDemat", "vortex-random-pos", function(self)
        if not self:GetData("demat-fast", false)
            and not self:GetData("redecorate")
            and not self:GetData("redecorate_parent")
        then
            self:ChangePosition(self:GetRandomLocation(false), self:GetAngles(), false)
        end
    end)

else
    ENT:OnMessage("demat", function(self)
        self:SetData("demat",true)
        self:SetData("step",1)
        self:SetData("teleport",true)
        if TARDIS:GetSetting("teleport-sound") and TARDIS:GetSetting("sound") then
            local shouldPlayExterior = self:CallHook("ShouldPlayDematSound", false)~=false
            local shouldPlayInterior = self:CallHook("ShouldPlayDematSound", true)~=false
            if not (shouldPlayExterior or shouldPlayInterior) then return end
            local ext = self:GetExtMetadata().Sounds.Teleport
            local int = self:GetIntMetadata().Sounds.Teleport

            local sound_demat_ext = ext.demat
            local sound_demat_int = int.demat or ext.demat
            local sound_fullflight_ext = ext.fullflight
            local sound_fullflight_int = int.fullflight or ext.fullflight

            if (self:GetData("health-warning", false) or self:GetData("force-demat", false))
                and not self:GetData("redecorate")
            then
                sound_demat_ext = ext.demat_damaged
                sound_demat_int = int.demat_damaged or ext.demat_damaged
                sound_fullflight_ext = ext.fullflight_damaged
                sound_fullflight_int = int.fullflight_damaged or ext.fullflight_damaged
            end

            local pos = net.ReadVector()
            
            if LocalPlayer():GetTardisData("exterior")==self then
                local intsound = int.demat or ext.demat
                local extsound = ext.demat
                if (self:GetData("demat-fast",false))==true then
                    if shouldPlayInterior then
                        self.interior:EmitSound(sound_fullflight_int)
                    end
                    if shouldPlayExterior then
                        self:EmitSound(sound_fullflight_ext)
                    end
                else
                    if shouldPlayInterior then
                        self.interior:EmitSound(sound_demat_int)
                    end
                    if shouldPlayExterior then
                        self:EmitSound(sound_demat_ext)
                    end
                end
            elseif shouldPlayExterior then
                sound.Play(sound_demat_ext,self:GetPos())
                if pos and self:GetData("demat-fast",false) then
                    if not IsValid(self) then return end
                    if (self:GetData("demat-fast",false))==true then
                        sound.Play(ext.mat_damaged, pos)
                    else
                        sound.Play(ext.mat, pos)
                    end
                end
            end
        end
    end)

    ENT:OnMessage("premat", function(self)
        self:SetData("teleport",true)
        if TARDIS:GetSetting("teleport-sound") and TARDIS:GetSetting("sound") then
            local shouldPlayExterior = self:CallHook("ShouldPlayMatSound", false)~=false
            local shouldPlayInterior = self:CallHook("ShouldPlayMatSound", true)~=false
            if not (shouldPlayExterior or shouldPlayInterior) then return end
            local ext = self:GetExtMetadata().Sounds.Teleport
            local int = self:GetIntMetadata().Sounds.Teleport
            local pos=net.ReadVector()
            if LocalPlayer():GetTardisData("exterior")==self and (not self:GetData("demat-fast",false)) then
                if self:GetData("health-warning", false) then
                    if shouldPlayExterior then
                        self:EmitSound(ext.mat_damaged)
                    end
                    if shouldPlayInterior then
                        self.interior:EmitSound(int.mat_damaged or ext.mat_damaged)
                    end
                else
                    if shouldPlayExterior then
                        self:EmitSound(ext.mat)
                    end
                    if shouldPlayInterior then
                        self.interior:EmitSound(int.mat or ext.mat)
                    end
                end
            elseif not self:GetData("demat-fast",false) and shouldPlayExterior then
                if self:GetData("health-warning", false) then
                    sound.Play(ext.mat_damaged,pos)
                else
                    sound.Play(ext.mat,pos)
                end
            end
        end
    end)

    ENT:OnMessage("mat", function(self)
        self:SetData("mat",true)
        self:SetData("step",1)
        self:SetData("vortex",false)
    end)

    function ENT:StopDemat()
        self:SetData("demat",false)
        self:SetData("step",1)
        self:SetData("vortex",true)
        self:SetData("teleport",false)
        self:CallHook("StopDemat")
    end

    function ENT:StopMat()
        self:SetData("mat",false)
        self:SetData("step",1)
        self:SetData("teleport",false)
    end

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

function ENT:GetTargetAlpha()
    local demat=self:GetData("demat")
    local mat=self:GetData("mat")
    local step=self:GetData("step",1)
    if demat and (not mat) then
        return self:GetExtMetadata().Teleport.DematSequence[step]
    elseif mat and (not demat) then
        return self:GetExtMetadata().Teleport.MatSequence[step]
    else
        return 255
    end
end

ENT:AddHook("Think","teleport",function(self,delta)
    local demat=self:GetData("demat")
    local mat=self:GetData("mat")
    if not (demat or mat) then return end
    local alpha=self:GetData("alpha",255)
    local target=self:GetData("alphatarget",255)
    local step=self:GetData("step",1)
    if alpha==target then
        if demat then
            if step>=#self:GetExtMetadata().Teleport.DematSequence then
                self:StopDemat()
                return
            else
                self:SetData("step",step+1)
            end
        elseif mat then
            if step>=#self:GetExtMetadata().Teleport.MatSequence then
                self:StopMat()
                return
            else
                self:SetData("step",step+1)
            end
        end
        target=self:GetTargetAlpha()
        self:SetData("alphatarget",target)
    end
    local sequencespeed = (self:GetData("demat-fast",false) and self:GetExtMetadata().Teleport.SequenceSpeedFast or self:GetExtMetadata().Teleport.SequenceSpeed)
    alpha=math.Approach(alpha,target,delta*66*sequencespeed)
    self:SetData("alpha",alpha)
    local attached=self:GetData("demat-attached")
    if attached then
        for k,v in pairs(attached) do
            if IsValid(k) then
                if not (v==0) then
                    if not (k:GetRenderMode()==RENDERMODE_TRANSALPHA) then
                        k:SetRenderMode(RENDERMODE_TRANSALPHA)
                    end
                    k:SetColor(ColorAlpha(k:GetColor(),alpha))
                end
            end
        end
    end
end)


