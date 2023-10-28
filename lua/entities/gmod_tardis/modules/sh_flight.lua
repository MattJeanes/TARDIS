-- Flight

-- Binds
TARDIS:AddKeyBind("flight-toggle",{
    name="ToggleFlight",
    section="ThirdPerson",
    func=function(self,down,ply)
        if ply==self.pilot and down then
            TARDIS:Control("flight", ply)
        end
    end,
    key=KEY_R,
    serveronly=true,
    exterior=true
})

TARDIS:AddKeyBind("handbrake",{
    name="Handbrake",
    section="ThirdPerson",
    func=function(self,down,ply)
        if down and ply == self.pilot then
            TARDIS:Control("handbrake", ply)
        end
    end,
    key=KEY_J,
    serveronly=true,
    exterior=true
})

TARDIS:AddKeyBind("flight-forward",{
    name="Forward",
    section="Flight",
    key=KEY_W,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-backward",{
    name="Backward",
    section="Flight",
    key=KEY_S,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-left",{
    name="Left",
    section="Flight",
    key=KEY_A,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-right",{
    name="Right",
    section="Flight",
    key=KEY_D,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-up",{
    name="Up",
    section="Flight",
    key=KEY_SPACE,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-down",{
    name="Down",
    section="Flight",
    key=KEY_LCONTROL,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-boost",{
    name="Boost",
    section="Flight",
    key=KEY_LSHIFT,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-rotate",{
    name="Rotate",
    section="Flight",
    key=KEY_LALT,
    serveronly=true,
    exterior=true
})
TARDIS:AddKeyBind("flight-spindir",{
    name="SpinDirection",
    section="Flight",
    func=function(self,down,ply)
        if down and ply==self.pilot then
            TARDIS:Control("spin_cycle", ply)
        end
    end,
    key=MOUSE_RIGHT,
    serveronly=true,
    exterior=true
})

if SERVER then
    function ENT:ToggleFlight()
        local on = not self:GetData("flight",false)
        return self:SetFlight(on)
    end

    function ENT:InterruptFlight()
        if not self:GetData("flight") and not self:GetData("vortex") then return end

        if TARDIS:GetSetting("flight_interrupt_to_float", self) then
            self:SetData("floatfirst", true)
        end

        self:ToggleFlight()
        self:CallCommonHook("FlightInterrupted")

        self:ExplodeIfFast()
    end

    function ENT:SetFlight(on)
        if not on and self:CallHook("CanTurnOffFlight")==false then
            return false
        end
        if on and self:CallHook("CanTurnOnFlight")==false then
            return false
        end
        if on and self:GetPhyslock()==true then
            local pilot = self:GetData("pilot",nil)
            if IsValid(pilot) and pilot:IsPlayer() then
                TARDIS:Message(pilot, "Flight.WarnPhyslockEngaged")
            end
        end
        self:SetData("flight",on,true)
        self:CallCommonHook("FlightToggled", on)
        self:SetFloat(on)
        return true
    end

    ENT:AddHook("PowerToggled", "flight", function(self,on)
        if on and self:GetData("power-lastflight",false)==true then
            self:SetFlight(true)
        else
            self:SetData("power-lastflight",self:GetData("flight",false))
            self:SetFlight(false)
        end
    end)

    ENT:AddHook("ShouldTurnOnRotorwash", "flight", function(self)
        if self:GetData("flight") then
            return true
        end
    end)

    ENT:AddHook("CanTurnOffFloat", "flight", function(self)
        if self:GetData("flight") then return false end
    end)

    ENT:AddHook("CanTurnOnFlight", "flight", function(self)
        if not self:GetPower() then
            return false
        end
    end)

    ENT:AddHook("ThirdPerson", "flight", function(self,ply,enabled)
        if enabled then
            if IsValid(self.pilot) then
                TARDIS:Message(ply, "Flight.NameIsThePilot", self.pilot:Nick())
            elseif self:CallHook("CanChangePilot",ply)~=false then
                self.pilot=ply
                TARDIS:Message(ply, "Flight.YouAreNowThePilot")
                self:CallHook("PilotChanged",nil,ply)
            end
        else
            local waspilot=self.pilot==ply
            if IsValid(self.pilot) and waspilot then
                self.pilot=nil
                for k,v in pairs(self.occupants) do
                    if k:GetTardisData("thirdperson") then
                        if IsValid(self.pilot) then
                            TARDIS:Message(k, "Flight.NameIsNowThePilot", self.pilot:Nick())
                        else
                            self.pilot=k
                            TARDIS:Message(k, "Flight.YouAreNowThePilot")
                        end
                    end
                end
            end
            if waspilot then
                if IsValid(self.pilot) then
                    TARDIS:Message(ply, "Flight.NameIsNowThePilot", self.pilot:Nick())
                else
                    TARDIS:Message(ply, "Flight.NoLongerPilot")
                end
                self:CallHook("PilotChanged",ply,self.pilot)
            end
        end
    end)

    ENT:AddHook("PilotChanged","flight",function(self,old,new)
        self:SetData("pilot",new,true)
        self:SendMessage("PilotChanged", {old, new} )
    end)

    ENT:AddHook("Think", "flight", function(self)
        if self:GetData("flight") then
            self.phys:Wake()
        end
    end)

    ENT:AddHook("PhysicsUpdate", "flight", function(self,ph)
        if self:GetData("flight") then
            local phm=FrameTime()*66

            local up=self:GetUp()
            local ri2=self:GetRight()
            local left=ri2*-1
            local fwd2=self:GetForward()
            local ang=self:GetAngles()
            local angvel=ph:GetAngleVelocity()
            local vel=ph:GetVelocity()
            local vell=ph:GetVelocity():Length()
            local cen=ph:GetMassCenter()
            local mass=ph:GetMass()
            local lev=ph:GetInertia():Length()
            local force=15
            local vforce=5
            local rforce=2
            local tforce=200
            local tilt=0
            local control=self:CallHook("FlightControl")~=false

            local spindir = self:GetSpinDir()
            local spin = (spindir ~= 0)
            local brakes = false

            local broken = self:IsBroken()
            local warning = not broken and self:IsDamaged()

            local fbinds = {
                forward = TARDIS:IsBindDown(self.pilot,"flight-forward"),
                backward = TARDIS:IsBindDown(self.pilot,"flight-backward"),
                left = TARDIS:IsBindDown(self.pilot,"flight-left"),
                right = TARDIS:IsBindDown(self.pilot,"flight-right"),
                rotate = TARDIS:IsBindDown(self.pilot,"flight-rotate"),
                up = TARDIS:IsBindDown(self.pilot,"flight-up"),
                down = TARDIS:IsBindDown(self.pilot,"flight-down"),
                boost = TARDIS:IsBindDown(self.pilot,"flight-boost"),
            }

            local function num_keys_pressed()
                local count = 0
                for k,v in pairs(fbinds) do
                    if v then
                        count = count + 1
                    end
                end
                return count
            end

            local function VectorClamp(vec, minv, maxv)
                local x = math.Clamp(vec.x, minv, maxv)
                local y = math.Clamp(vec.y, minv, maxv)
                local z = math.Clamp(vec.z, minv, maxv)
                return Vector(x,y,z)
            end

            local function stabilize()
                -- lean into the flight
                ph:ApplyForceOffset( vel * 0.005,            cen + up * lev)
                ph:ApplyForceOffset(-vel * 0.005,            cen - up * lev)

                -- stabilise pitch
                ph:ApplyForceOffset( up * -ang.p,          cen - fwd2 * lev)
                ph:ApplyForceOffset(-up * -ang.p,          cen + fwd2 * lev)

                -- stabilise roll and apply tilt
                ph:ApplyForceOffset( up * -(ang.r - tilt), cen - ri2 * lev)
                ph:ApplyForceOffset(-up * -(ang.r - tilt), cen + ri2 * lev)

                local angbrake=angvel*-0.015
                ph:AddAngleVelocity(angbrake)

                local brake=vel*-0.01
                ph:AddVelocity(brake)
            end

            if broken and vell > 200 then
                local last_dir_change = self:GetData("broken_flight_dir_change_time", 0)

                local pressed_data = self:GetData("flight_num_keys_pressed", 0)
                local pressed = num_keys_pressed()
                local pressed_recently = (pressed_data < pressed)
                if pressed ~= pressed_data then
                    self:SetData("flight_num_keys_pressed", pressed)
                end

                if (CurTime() > last_dir_change and vell < 2000) or pressed_recently then
                    if math.random(5) <= 2 then
                        self:Explode(0)
                        self:SendMessage("ext_sparks", {1})
                        self:SetData("broken_flight_last_explode", CurTime())

                        ph:SetAngleVelocity(AngleRand():Forward() * vell)
                    end

                    local stabilize = (math.random(6) == 1 or fbinds.rotate)
                    self:SetData("broken_flight_stabilize", stabilize)

                    self:SetData("broken_flight_dir_change_time", CurTime() + math.random(3) - 0.5)
                    ph:AddVelocity(-0.3 * vel + AngleRand():Forward() * vell * math.Rand(2,4))
                end

                if vell < 2000 then
                    ph:AddVelocity(vel * 0.02)
                end

                if self:GetData("broken_flight_stabilize") then
                    stabilize()
                elseif angvel:Length() > 450 and CurTime() - self:GetData("broken_flight_last_explode", CurTime()) > 1 then
                    local angbrake=angvel*-0.015
                    ph:AddAngleVelocity(angbrake)
                else
                    ph:AddAngleVelocity(AngleRand():Forward() * 40)
                    local vec=Vector(0,vell / 10000,0)
                    vec:Rotate(ang)
                    ph:AddAngleVelocity(vec)
                end

                return
            end

            if self.pilot and IsValid(self.pilot) and control then
                local p=self.pilot
                local eye=p:GetTardisData("viewang")
                if not eye then
                    eye=angle_zero
                end
                local fwd=eye:Forward()
                local ri=eye:Right()

                if fbinds.boost then

                    local force_mult
                    local door = self:GetData("doorstatereal", false)

                    if door and TARDIS:GetSetting("opened-door-no-boost", self) then
                        force_mult = 0.25
                        brakes = true -- no spin, no tilt
                        local lastmsg = self.bad_flight_boost_msg
                        if lastmsg == nil or (lastmsg ~= nil and CurTime() - lastmsg > 5.5) then
                            self.bad_flight_boost_msg = CurTime()
                            TARDIS:ErrorMessage(self.pilot, "Flight.DoorOpenNoBoost")
                        end
                    else
                        if self.bad_flight_boost_msg ~= nil then
                            self.bad_flight_boost_msg = nil
                        end
                        force_mult = TARDIS:GetSetting("boost-speed")
                        if not spin then
                            force_mult = math.max(1, force_mult * 0.6)
                        end
                    end

                    force = force * force_mult
                    vforce = vforce * force_mult
                    rforce = rforce * force_mult
                elseif self.bad_flight_boost_msg ~= nil then
                    self.bad_flight_boost_msg = nil
                end
                if fbinds.forward then
                    ph:AddVelocity(fwd*force*phm)
                    tilt=tilt+5
                end
                if fbinds.backward then
                    ph:AddVelocity(-fwd*force*phm)
                    tilt=tilt+5
                end
                if fbinds.right then
                    if fbinds.rotate then
                        ph:AddAngleVelocity(Vector(0,0,-rforce))
                    else
                        ph:AddVelocity(ri*force*phm)
                        tilt=tilt+5
                    end
                end
                if fbinds.left then
                    if fbinds.rotate then
                        ph:AddAngleVelocity(Vector(0,0,rforce))
                    else
                        ph:AddVelocity(-ri*force*phm)
                        tilt=tilt+5
                    end
                end

                if fbinds.down then
                    ph:AddVelocity(-up*vforce*phm)
                elseif fbinds.up then
                    ph:AddVelocity(up*vforce*phm)
                end
            end

            if not spin or brakes then
                tilt = 0
            end

            if warning then
                local health_mult = (5 + self.HEALTH_PERCENT_DAMAGED - self:GetHealthPercent()) / 10

                local pressed_data = self:GetData("flight_num_keys_pressed", 0)
                local pressed = num_keys_pressed()
                if pressed_data < pressed then
                    local skid = AngleRand():Forward() * vell * (0.2 + math.random()) * health_mult
                    ph:AddVelocity(skid)
                end

                if pressed ~= pressed_data then
                    self:SetData("flight_num_keys_pressed", pressed)
                end
            end

            if spin and not brakes then
                local twist = Vector(0, 0, -spindir * math.sqrt(vell / tforce))
                ph:AddAngleVelocity(twist)
            end

            stabilize()
        end
    end)

    ENT:AddHook("HandleE2", "flight", function(self, name, e2, ...)
        local args = {...}
        if name == "Flightmode" and TARDIS:CheckPP(e2.player, self) then
            local on = args[1]
            if on then
                return self:SetFlight(on) and 1 or 0
            else
                return self:ToggleFlight() and 1 or 0
            end
        elseif name == "Spinmode" and TARDIS:CheckPP(e2.player, self) then
            local spindir = args[1]
            self:SetSpinDir(spindir)
            return self:GetSpinDir()
        elseif name == "Track" and TARDIS:CheckPP(e2.player, self) then
            return 0 -- Not yet implemented
        end
    end)

    ENT:AddHook("HandleE2", "flight_get", function(self, name, e2)
        if name == "GetFlying" then
            return self:GetData("flight",false) and 1 or 0
        elseif name == "GetTracking" then
            return NULL --We don't have flight tracking yet
        elseif name == "GetPilot" then
            return self:GetData("pilot", NULL) or NULL
        end
    end)

    ENT:AddHook("ShouldNotPlayLandingSound", "flight", function(self)
        if self:GetData("flight") or self:GetData("float") then
            return true
        end
    end)
else
    ENT:AddHook("OnRemove", "flight", function(self)
        if self.flightsound then
            self.flightsound:Stop()
            self.flightsound=nil
        end
    end)

    function ENT:ChooseFlightSound()
        if self:IsBroken() then
            self.flightsound = CreateSound(self, self.metadata.Exterior.Sounds.FlightLoopBroken)
            self.flightsounddamaged = false
            self.flightsoundbroken = true
        elseif self:IsDamaged() then
            self.flightsound = CreateSound(self, self.metadata.Exterior.Sounds.FlightLoopDamaged)
            self.flightsounddamaged = true
            self.flightsoundbroken = false
        else
            self.flightsound = CreateSound(self, self.metadata.Exterior.Sounds.FlightLoop)
            self.flightsounddamaged = false
            self.flightsoundbroken = false
        end
    end

    function ENT:IsFlightSoundWrong()
        if self.flightsounddamaged ~= self:IsDamaged() then return true end
        if self.flightsoundbroken ~= self:IsBroken() then return true end
        return false
    end

    ENT:AddHook("Think", "flight", function(self)
        if self:GetData("flight") and TARDIS:GetSetting("flight-externalsound")
            and TARDIS:GetSetting("sound") and (not self:CallHook("ShouldTurnOffFlightSound"))
        then
            if self.flightsound and self.flightsound:IsPlaying() then
                local p=math.Clamp(self:GetVelocity():Length()/250,0,15)
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
                    self.flightsound:ChangePitch(95+p,0.1)
                else
                    local pos = e:GetPos()
                    local spos = self:GetPos()
                    local doppler = (pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200
                    self.flightsound:ChangePitch(math.Clamp(95+p+doppler,80,120),0.1)
                end
                self.flightsound:ChangeVolume(0.75)

                if self:IsFlightSoundWrong() then
                    self.flightsound:Stop()
                    self:ChooseFlightSound()
                    self.flightsound:SetSoundLevel(90)
                    self.flightsound:Play()
                end
            else
                self:ChooseFlightSound()
                self.flightsound:SetSoundLevel(90)
                self.flightsound:Play()
            end
        elseif self.flightsound then
            self.flightsound:Stop()
            self.flightsound=nil
        end
    end)

    ENT:OnMessage("PilotChanged", function(self, data, ply)
        local old=data[1]
        local new=data[2]
        self:CallHook("PilotChanged",old,new)
    end)

    ENT:OnMessage("ext_sparks", function(self, data, ply)
        self:ExteriorSparks(data and data[1] or 1)
    end)
end