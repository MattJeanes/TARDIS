-- Vortex

function ENT:IsVortexEnabled(pilot)
    local hookResult = self:CallHook("VortexEnabled", pilot)
    if hookResult ~= nil then return hookResult end
    return ((not pilot and SERVER) or TARDIS:GetSetting("vortex-enabled",false,pilot)) and IsValid(self:GetPart("vortex")) and (SERVER or self:GetData("vortexmodelvalid"))
end

ENT:AddHook("VortexEnabled", "demat-fast", function(self, pilot)
    if self:GetData("demat-fast", false) then
        return false
    end
end)

if SERVER then
    ENT:AddHook("PhysicsUpdate","vortex",function(self,ph)
        -- Simulate flight without actually moving anywhere
        if self:GetData("vortex") then
            local vel=ph:GetVelocity()
            local brake=vel*-(self:GetData("vortexready") and 1 or 0.02)
            ph:AddVelocity(brake)
            
            if IsValid(self.pilot) and self:IsVortexEnabled(self.pilot) then
                local up=self:GetUp()
                local ri2=self:GetRight()
                local fwd2=self:GetForward()
                local ang=self:GetAngles()
                local cen=ph:GetMassCenter()
                local lev=ph:GetInertia():Length()
                
                local vel=0
                local rforce=2
                local mul=3
                local tilt=0
                local tiltmul=7
                if TARDIS:IsBindDown(self.pilot,"flight-forward")
                    or TARDIS:IsBindDown(self.pilot,"flight-left")
                    or TARDIS:IsBindDown(self.pilot,"flight-right")
                    or TARDIS:IsBindDown(self.pilot,"flight-backward") then
                    vel=vel+1
                    tilt=tilt+1
                end
                if TARDIS:IsBindDown(self.pilot,"flight-boost") then
                    mul=mul*2
                    tiltmul=tiltmul*2
                end
                if TARDIS:IsBindDown(self.pilot,"float-boost") then
                    rforce=rforce*2.5
                end
                if TARDIS:IsBindDown(self.pilot,"float-brake") then
                    ph:AddAngleVelocity(ph:GetAngleVelocity()*-0.05)
                end
                if TARDIS:IsBindDown(self.pilot,"flight-rotate") then
                    if TARDIS:IsBindDown(self.pilot,"flight-left") then
                        ph:AddAngleVelocity(Vector(0,0,rforce))
                    elseif TARDIS:IsBindDown(self.pilot,"flight-right") then
                        ph:AddAngleVelocity(Vector(0,0,-rforce))
                    end
                elseif not (self:GetSpinDir() == 0) then
                    local twist=Vector(0, 0, vel * mul * - self:GetSpinDir())
                    ph:AddAngleVelocity(twist)
                    ph:ApplyForceOffset( up*-ang.p,cen-fwd2*lev)
                    ph:ApplyForceOffset(-up*-ang.p,cen+fwd2*lev)
                    ph:ApplyForceOffset( up*-(ang.r-(tilt*tiltmul)),cen-ri2*lev)
                    ph:ApplyForceOffset(-up*-(ang.r-(tilt*tiltmul)),cen+ri2*lev)
                end
            end
        end
    end)
    
    ENT:AddHook("FlightControl","vortex",function(self)
        if self:GetData("vortex") then
            return false
        end
    end)
    
    ENT:AddHook("CanTurnOffFlight", "flight", function(self)
        if self:GetData("vortex") then
            return false
        end
    end)
    
    ENT:AddHook("DoorCollisionOverride","vortex",function(self)
        if self:GetData("vortex") and self:IsVortexEnabled() then
            return true -- forces door collision to stay on
        end
    end)
    
    ENT:AddHook("CanToggleDoor","vortex",function(self,state)
        if self:GetData("vortex") and (not self:IsVortexEnabled()) then
            return false
        end
    end)
else
    TARDIS:AddSetting({
        id="vortex-enabled",
        name="Show Vortex",
        desc="Whether the vortex is shown during vortex flight",
        section="Misc",
        value=true,
        type="bool",
        option=true,
        networked=true
    })
    
    ENT:AddHook("Think","vortex",function(self)
        local alpha = self:GetData("vortexalpha",0)
        local enabled = self:IsVortexEnabled()
        local target = self:GetData("vortex") and 1 or 0
        if TARDIS:GetExteriorEnt()==self and enabled then
            if alpha ~= target then
                if alpha==0 and target==1 then
                    self:SetData("lockedang",Angle(0,self:LocalToWorldAngles(self:GetPart("vortex").ang).y,0))
                end
                alpha = math.Approach(alpha,self:GetData("vortex") and 1 or 0,FrameTime()*0.5)
                self:SetData("vortexalpha",alpha)
            end
        else
            if alpha~=target then
                alpha = target
                self:SetData("vortexalpha",alpha)
            end
        end
    end)
    
    local function dopredraw(self,part)
        local vortexpart = (part and part.ID=="vortex")
        local target = self:GetData("vortex") and 1 or 0
        local alpha = self:GetData("vortexalpha",0)
        local enabled = self:IsVortexEnabled()
        if TARDIS:GetExteriorEnt()==self and enabled then
            if (not (target == 0 and alpha == 0)) or vortexpart then
                render.SetBlend(alpha)
                if alpha>0 and self:CallHook("ShouldVortexIgnoreZ") then
                    cam.IgnoreZ(true)
                end
            end
        else
            if vortexpart or self:GetData("vortex") then
                render.SetBlend(0)
            end
        end
    end
    
    local function dodraw(self,part)
        render.SetBlend(1)
        local vortexalpha = self:GetData("vortexalpha",0)
        if vortexalpha>0 then
            if not part and TARDIS:GetExteriorEnt()==self then
                local attached = self:GetData("demat-attached")
                if attached then
                    local oldblend = render.GetBlend()
                    render.SetBlend(vortexalpha)
                    for k,v in pairs(attached) do
                        if IsValid(k) and k.DrawModel and v>0 then
                            local oldc = k:GetColor()
                            k:SetColor(ColorAlpha(oldc,v))
                            k:DrawModel()
                            k:SetColor(oldc)
                        end
                    end
                    render.SetBlend(oldblend)
                end
            end
            cam.IgnoreZ(false)
        end
    end
    ENT:AddHook("PreDraw","vortex",dopredraw)
    ENT:AddHook("PreDrawPart","vortex",dopredraw)
    ENT:AddHook("Draw","vortex",dodraw)
    ENT:AddHook("DrawPart","vortex",dodraw)
    ENT:AddHook("PreDrawPortal","vortex",dopredraw)
    ENT:AddHook("PostDrawPortal","vortex",dodraw)
    
    ENT:AddHook("ShouldNotRenderPortal","vortex",function(self,parent,portal,exit)
        if self:GetData("vortex") and (TARDIS:GetExteriorEnt()~=self or (not self:IsVortexEnabled())) then
            return true, self~=parent
        end
    end)
    
    ENT:AddHook("StopDemat","vortex",function(self)
        local vortex=self:GetPart("vortex")
        local valid = false
        if IsValid(vortex) then
            valid = util.IsValidModel(vortex.model)
        end
        if not valid and self:GetData("hasvortex") and (not self:GetData("vortexmodelwarn")) then
            TARDIS:Message(LocalPlayer(), "WARNING: Vortex model invalid - disabling vortex, are you missing a dependency?")
            self:SetData("vortexmodelwarn",true)
        end
        self:SetData("vortexmodelvalid",valid)
    end)
    
    ENT:AddHook("ShouldTurnOffLight","vortex",function(self)
        if self:GetData("vortex") and (TARDIS:GetExteriorEnt()~=self or (not self:IsVortexEnabled())) then
            return true
        end
    end)

    ENT:AddHook("ShouldEmitDoorSound", "vortex", function(self)
        if self:GetData("vortex") and LocalPlayer():GetTardisData("exterior")~=self then
            return false
        end
    end)
end
