if SERVER then
	ENT:AddHook("PhysicsUpdate", "falling", function(self,ph)
        if self:GetData("float") or self:GetData("flight") or self:IsPlayerHolding()
            or not ph:IsGravityEnabled() or not self:IsAlive()
        then
            if self:GetData("falling") then
                self:SetData("falling", false, true)
            end
            if self:GetData("falling_start_time") then
                self:SetData("falling_start_time", nil, true)
            end
            if self:GetData("free_movement_start_time") then
                self:SetData("free_movement_start_time", nil, true)
            end
            return
        end

        local vel=ph:GetVelocity()

        if not self:GetData("free_movement_start_time") then
            self:SetData("free_movement_start_time", CurTime(), true)
        end

        local phm=FrameTime()*66
        local up=self:GetUp()
        local ri2=self:GetRight()
        local fwd2=self:GetForward()
        local ang=self:GetAngles()
        local vel=ph:GetVelocity()
        local vell=ph:GetVelocity():Length()
        local cen=ph:GetMassCenter()
        local mass=ph:GetMass()
        local lev=ph:GetInertia():Length()
        local angv=ph:GetAngleVelocity()

        local function is_ground_underneath()
            local td = {}
            local ply = self:GetCreator()
            td.mins = self:OBBMins()
            td.maxs = self:OBBMaxs()
            td.maxs.z = (td.maxs.z - td.mins.z) * 0.5
            td.mins.z = 0
            td.filter = { self, }

            for k,v in pairs(self:GetParts()) do
                table.insert(td.filter, v)
            end

            local bottom = Vector(0, 0, -td.maxs.z * 1.01)
            bottom:Rotate(self:GetAngles())
            local point = self:GetPos() + bottom

            td.start = point
            td.endpos = point
            return util.TraceHull(td).Hit
        end

        local falling = self:GetData("falling")
        local stop_time = self:GetData("falling_stop_time")
        local start_time = self:GetData("falling_start_time")

        local z_ang_max = math.max(math.abs(ang.x), math.abs(ang.y))
        local xy_vel_max = math.max(math.abs(vel.x), math.abs(vel.y))

        local pressing_down = IsValid(self.pilot) and TARDIS:IsBindDown(self.pilot,"flight-down")
        local should_align_vertically = (start_time and CurTime() - start_time > 0.8)
        should_align_vertically = should_align_vertically and xy_vel_max < 400 and z_ang_max < 20

        if (vel.z < -100 and should_align_vertically) or pressing_down then
            falling = true
            self:SetData("falling", falling, true)
            self:SetData("falling_stop_time", nil)

            if vel.z < -1000 then
                self:SetData("falling_hard", true)
            end

            local angv_fast = (angv.x > 50 or angv.y > 50)

            if (math.abs(ang.p) > 10 or math.abs(ang.r) > 10) and not angv_fast then
                ph:ApplyForceOffset( up * -ang.p * 5, cen - fwd2 * lev)
                ph:ApplyForceOffset(-up * -ang.p * 5, cen + fwd2 * lev)
                ph:ApplyForceOffset( up * -ang.r * 5, cen - ri2 * lev)
                ph:ApplyForceOffset(-up * -ang.r * 5, cen + ri2 * lev)
            else
                if angv_fast then
                    ph:SetAngleVelocityInstantaneous(Vector(angv.x * 0.9, angv.y * 0.9, angv.z))
                end
            end
        elseif vel.z < -100 then
            if not start_time then
                self:SetData("falling_start_time", CurTime())
            end

        elseif falling and vel.z >= 0 then

            if not stop_time then
                self:SetData("falling_stop_time", CurTime())
                self:SendMessage("fall_landing", { self:GetData("falling_hard") } )
                self:SetData("falling_hard", nil)
            elseif CurTime() - stop_time > 1 and not self:GetData("mat") then
                self:SetData("falling", false, true)
            end

            if is_ground_underneath() and math.abs(ang.p) <= 35 and math.abs(ang.r) <= 35 and vel.z > 0 then
                local newvel_x = math.Clamp(vel.x * 0.05,-30,30)
                local newvel_y = math.Clamp(vel.y * 0.05,-30,30)

                ph:SetVelocityInstantaneous(-up * 50 * phm)
                ph:AddVelocity(Vector(newvel_x,newvel_y,0))

                local newavel_x = math.Clamp(angv.x * 0.1,-300,300)
                local newavel_y = math.Clamp(angv.y * 0.1,-300,300)
                local newavel_z = math.Clamp(angv.z * 0.1,-300,300)
                ph:SetAngleVelocityInstantaneous(Vector(newavel_x,newavel_y,newavel_z))
            end
        end
    end)
else
    ENT:OnMessage("fall_landing", function(self, data, ply)
        if not TARDIS:GetSetting("sound") then return end

        local hard = data[1]
        local snds = self.metadata.Exterior.Sounds

        if not hard and CurTime() - self:GetData("fall_sound_last", 0) < 2 then return end
        self:SetData("fall_sound_last", CurTime())

        if TARDIS:GetSetting("flight-externalsound") then
            if not hard then
                self:EmitSound(snds.FlightLand)
            else
                self:EmitSound(snds.FlightFall)
            end
        end

        if IsValid(self.interior) and TARDIS:GetSetting("flight-internalsound") then
            local snds_i = self.metadata.Interior.Sounds
            self.interior:EmitSound(snds_i.FlightLand or snds.FlightLand)
        end
    end)

    ENT:AddHook("Think", "falling", function(self)
        local free_movement_start = self:GetData("free_movement_start_time")
        if free_movement_start and CurTime() - free_movement_start > 1
            and TARDIS:GetSetting("flight-externalsound")
            and TARDIS:GetSetting("sound")
        then

            local time_mult = math.Clamp((CurTime() - free_movement_start - 1) / 5, 0, 1)

            local p=math.Clamp(self:GetVelocity():Length()/125,0,15)
            if self.fallsound and self.fallsound:IsPlaying() then
                local ply=LocalPlayer()
                local e=ply:GetViewEntity()
                if not IsValid(e) then e=ply end
                if e:EntIndex()==-1 then -- clientside prop
                    local ext=ply:GetTardisData("exterior")
                    if ext then
                        e=ext
                    else
                        e=ply
                    end
                end
                if ply:GetTardisData("exterior")==self and e==self.thpprop and ply:GetTardisData("outside") then
                    self.fallsound:ChangePitch(95+p,0.1)
                else
                    local pos = e:GetPos()
                    local spos = self:GetPos()
                    local doppler = (pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200
                    self.fallsound:ChangePitch(math.Clamp(95+p+doppler,80,120),0.1)
                end

                self.fallsound:ChangeVolume(time_mult * 0.75 * p / 20)
            else
                self.fallsound = CreateSound(self, self.metadata.Exterior.Sounds.FlightFallWind)
                self.fallsound:SetSoundLevel(90)
                self.fallsound:ChangeVolume(time_mult * 0.75 * p / 20)
                self.fallsound:Play()
            end
        elseif self.fallsound then
            self.fallsound:Stop()
            self.fallsound=nil
        end
    end)

    ENT:AddHook("OnRemove", "falling", function(self)
        if self.fallsound then
            self.fallsound:Stop()
            self.fallsound = nil
        end
    end)
end