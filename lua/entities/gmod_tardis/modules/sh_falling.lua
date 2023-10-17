if SERVER then
    function ENT:IsVerticalLanding(collision_data)
        local ang = self:GetAngles()
        local angmax = math.max(math.abs(ang.p), math.abs(ang.r))

        return (angmax < 30 and collision_data.HitNormal.z < -0.85 and collision_data.OurOldVelocity.z < 0)
    end

    ENT:AddHook("PhysicsCollide", "falling", function(self, data, collider)

        if self:IsVerticalLanding(data) then
            if self:CallHook("ShouldNotPlayLandingSound") ~= true then
                self:SendMessage((data.OurOldVelocity.z < -1500) and "fall_crashing_sound" or "fall_landing_sound")
            end

            self:SetData("vertbrakes", true)
            self:Timer("vertbrakes", 1, function()
                self:SetData("vertbrakes", false)
            end)
        end

    end)

	ENT:AddHook("PhysicsUpdate", "falling", function(self,ph)

        local free_movement = not self:GetData("float") and not self:GetData("flight") and not self:IsPlayerHolding()
        free_movement = free_movement and ph:IsGravityEnabled() and self:IsAlive()

        self:SetData("free_movement", free_movement, true)

        if not free_movement then
            if self:GetData("vertbrakes") then
                self:SetData("vertbrakes", false)
            end
            return
        end

        if not self:IsAlive() then return end

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

        local function align_in_flight()
            local angmax = math.max(math.abs(ang.p), math.abs(ang.r))
            local angvmax = math.max(math.abs(angv.x), math.abs(angv.y))

            ph:SetAngleVelocityInstantaneous(Vector(angv.x * 0.95, angv.y * 0.95, angv.z))

            if angvmax <= 50 and angmax > 10 then
                ph:ApplyForceOffset( up * -ang.p * 10, cen - fwd2 * lev)
                ph:ApplyForceOffset(-up * -ang.p * 10, cen + fwd2 * lev)
                ph:ApplyForceOffset( up * -ang.r * 10, cen - ri2 * lev)
                ph:ApplyForceOffset(-up * -ang.r * 10, cen + ri2 * lev)
            end
        end


        local function reduce_movement()
            if math.abs(ang.p) <= 35 and math.abs(ang.r) <= 35 and vel.z > 0 then
                local newvel_x = math.Clamp(vel.x * 0.05,-30,30)
                local newvel_y = math.Clamp(vel.y * 0.05,-30,30)

                ph:SetVelocityInstantaneous(-up * 100 * phm)
                ph:AddVelocity(Vector(newvel_x,newvel_y,0))

                local newavel_x = math.Clamp(angv.x * 0.1,-300,300)
                local newavel_y = math.Clamp(angv.y * 0.1,-300,300)
                local newavel_z = math.Clamp(angv.z * 0.1,-300,300)
                ph:SetAngleVelocityInstantaneous(Vector(newavel_x,newavel_y,newavel_z))
            end
        end

        local pressing_down = IsValid(self.pilot) and TARDIS:IsBindDown(self.pilot,"flight-down")
        local vertbrakes = self:GetData("vertbrakes")
        local stopped = (vell < 0.1)

        if pressing_down and not vertbrakes and vell > 5 then
            align_in_flight()
        end

        if vertbrakes then
            if stopped then
                self:SetData("vertbrakes", false)
                self:CancelTimer("vertbrakes")
            end
            reduce_movement()
        end
    end)
else
    ENT:OnMessage("fall_landing_sound", function(self, data, ply)
        if not TARDIS:GetSetting("sound") then return end
        if CurTime() - self:GetData("fall_sound_last", 0) < 2 then return end
        self:SetData("fall_sound_last", CurTime())

        local snds = self.metadata.Exterior.Sounds

        if TARDIS:GetSetting("flight-externalsound") then
            self:EmitSound(snds.FlightLand)
        end

        if IsValid(self.interior) and TARDIS:GetSetting("flight-internalsound") then
            local snds_i = self.metadata.Interior.Sounds
            self.interior:EmitSound(snds_i.FlightLand or snds.FlightLand)
        end
    end)

    ENT:OnMessage("fall_crashing_sound", function(self, data, ply)
        if not TARDIS:GetSetting("sound") then return end
        local snds = self.metadata.Exterior.Sounds

        if TARDIS:GetSetting("flight-externalsound") then
            self:EmitSound(snds.FlightFall)
        end

        if IsValid(self.interior) and TARDIS:GetSetting("flight-internalsound") then
            local snds_i = self.metadata.Interior.Sounds
            self.interior:EmitSound(snds_i.FlightFall or snds.FlightFall)
        end
    end)

    function ENT:CreateWindSound(time_mult, p)
        time_mult = time_mult or 0
        self.wind_sound = self.wind_sound or CreateSound(self, self.metadata.Exterior.Sounds.FlightFallWind)
        self.wind_sound:SetSoundLevel(90)
        self.wind_sound:ChangeVolume(time_mult * 0.75 * p / 20)
        self.wind_sound:Play()
    end

    function ENT:StopWindSound()
        if self.wind_sound then
            self.wind_sound:Stop()
            self.wind_sound = nil
        end
    end

    ENT:AddHook("Think", "wind_sound", function(self)
        if not self:GetData("free_movement") then
            self:SetData("free_movement_start", nil)
        elseif not self:GetData("free_movement_start") then
            self:SetData("free_movement_start", CurTime())
        end

        local free_movement_start = self:GetData("free_movement_start")
        local wind_sound_required = free_movement_start and (CurTime() - free_movement_start > 1)

        if not TARDIS:GetSetting("sound") or not TARDIS:GetSetting("flight-externalsound") or not wind_sound_required then
            self:StopWindSound()
            return
        end

        local time_mult = math.Clamp((CurTime() - free_movement_start - 1) / 5, 0, 1)

        local p=math.Clamp(self:GetVelocity():Length()/125,0,15)

        if not self.wind_sound or not self.wind_sound:IsPlaying() then
            self:CreateWindSound(time_mult, p)
            return
        end

        local ply=LocalPlayer()
        local e=ply:GetViewEntity()
        if not IsValid(e) then e=ply end

        if e:EntIndex()==-1 then -- clientside prop
            local ext=ply:GetTardisData("exterior")
            e = ext or ply
        end

        if ply:GetTardisData("exterior")==self and e==self.thpprop and ply:GetTardisData("outside") then
            self.wind_sound:ChangePitch(95+p,0.1)
        else
            local pos = e:GetPos()
            local spos = self:GetPos()
            local doppler = (pos:Distance(spos + e:GetVelocity()) - pos:Distance(spos + self:GetVelocity())) / 200
            self.wind_sound:ChangePitch(math.Clamp(95+p+doppler,80,120),0.1)
        end

        self.wind_sound:ChangeVolume(time_mult * 0.75 * p / 20)
    end)

    ENT:AddHook("OnRemove", "wind_sound", function(self)
        self:StopWindSound()
    end)
end