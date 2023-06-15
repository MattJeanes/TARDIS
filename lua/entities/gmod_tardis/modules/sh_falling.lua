if SERVER then
	ENT:AddHook("PhysicsUpdate", "falling", function(self,ph)
        if self:GetData("float") or self:GetData("flight") or self:IsPlayerHolding()
            or not ph:IsGravityEnabled()
        then
            if self:GetData("falling") then
                self:SetData("falling", false, true)
            end
            if self:GetData("free_movement") then
                self:SetData("free_movement", false, true)
            end
            return
        end

        local vel=ph:GetVelocity()

        if not self:GetData("free_movement") then
            self:SetData("free_movement", true, true)
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

        local falling = self:GetData("falling")
        local stop_time = self:GetData("falling_stop_time")

        if vel.z < -100 then
            falling = true
            self:SetData("falling", falling, true)
            self:SetData("falling_stop_time", nil)

            if vel.z < -1000 then
                self:SetData("falling_hard", true)
            end

            local angv_fast = (angv.x > 50 or angv.y > 50)

            if (math.abs(ang.p) > 5 or math.abs(ang.r) > 5) and not angv_fast then
                ph:ApplyForceOffset( up * -ang.p * 5, cen - fwd2 * lev)
                ph:ApplyForceOffset(-up * -ang.p * 5, cen + fwd2 * lev)
                ph:ApplyForceOffset( up * -ang.r * 5, cen - ri2 * lev)
                ph:ApplyForceOffset(-up * -ang.r * 5, cen + ri2 * lev)
            else
                if angv_fast then
                    ph:SetAngleVelocityInstantaneous(Vector(angv.x * 0.9, angv.y * 0.9, angv.z))
                end
            end
        elseif falling and vel.z >= 0 then

            if not stop_time then
                self:SetData("falling_stop_time", CurTime())
                self:SendMessage("fall_landing", { self:GetData("falling_hard") } )
                self:SetData("falling_hard", nil)
            elseif CurTime() - stop_time > 1 and not self:GetData("mat") then
                self:SetData("falling", false, true)
            end

            if math.abs(ang.p) <= 45 and math.abs(ang.r) <= 45 and vel.z > 0 then
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
        if self:GetData("free_movement")
            and TARDIS:GetSetting("flight-externalsound")
            and TARDIS:GetSetting("sound")
        then
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

                self.fallsound:ChangeVolume(0.75 * p / 20)
            else
                self.fallsound = CreateSound(self, self.metadata.Exterior.Sounds.FlightFallWind)
                self.fallsound:SetSoundLevel(90)
                self.fallsound:ChangeVolume(0.75 * p / 20)
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