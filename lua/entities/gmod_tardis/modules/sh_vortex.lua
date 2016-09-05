-- Vortex

function ENT:IsVortexEnabled(pilot)
	return ((not pilot and SERVER) or TARDIS:GetSetting("vortex-enabled",false,pilot)) and IsValid(self:GetPart("vortex")) and (SERVER or self:GetData("vortexmodelvalid"))
end

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
				local mul=3
				local tilt=0
				local tiltmul=7
				if TARDIS:IsBindDown(self.pilot,"float-forward")
					or TARDIS:IsBindDown(self.pilot,"float-left")
					or TARDIS:IsBindDown(self.pilot,"float-right")
					or TARDIS:IsBindDown(self.pilot,"float-backward") then
					vel=vel+1
					tilt=tilt+1
				end
				if TARDIS:IsBindDown(self.pilot,"float-boost") then
					mul=mul*2
					tiltmul=tiltmul*2
				end
				if TARDIS:IsBindDown(self.pilot,"float-brake") then
					ph:AddAngleVelocity(ph:GetAngleVelocity()*-0.05)
				end
				if not (self.spindir==0) then
					local twist=Vector(0,0,vel*mul*-self.spindir)
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
		name="Vortex",
		desc="Whether the vortex is shown during vortex flight",
		section="Teleport",
		value=true,
		type="bool",
		option=true,
		networked=true
	})
	
	local function dopredraw(self,part)
		local vortexpart = (part and part.ID=="vortex")
		local alpha = self:GetData("vortexalpha",0)
		local target = self:GetData("vortex") and 1 or 0
		local enabled = self:IsVortexEnabled()
		if TARDIS:GetExteriorEnt()==self and enabled then
			if alpha ~= target then
				if alpha==0 and target==1 then
					self:SetData("lockedang",Angle(0,self:LocalToWorldAngles(self:GetPart("vortex").ang).y,0))
				end
				alpha = math.Approach(alpha,self:GetData("vortex") and 1 or 0,FrameTime()*0.1)
				self:SetData("vortexalpha",alpha)
			end
			if (not (target == 0 and alpha == 0)) or vortexpart then
				render.SetBlend(alpha)
			end
		else
			if alpha~=target then
				self:SetData("vortexalpha",target)
			end
			if vortexpart or self:GetData("vortex") then
				render.SetBlend(0)
			end
		end
	end
	
	local function dodraw(self,part)
		render.SetBlend(1)
	end
	ENT:AddHook("PreDraw","vortex",dopredraw)
	ENT:AddHook("PreDrawPart","vortex",dopredraw)
	ENT:AddHook("Draw","vortex",dodraw)
	ENT:AddHook("DrawPart","vortex",dodraw)
	
	ENT:AddHook("ShouldNotRenderPortal","vortex",function(self,parent)
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
			LocalPlayer():ChatPrint("WARNING: Vortex model invalid - disabling vortex, are you missing a dependency?")
			self:SetData("vortexmodelwarn",true)
		end
		self:SetData("vortexmodelvalid",valid)
	end)
	
	ENT:AddHook("ShouldTurnOffLight","vortex",function(self)
		if self:GetData("vortex") and (TARDIS:GetExteriorEnt()~=self or (not self:IsVortexEnabled())) then
			return true
		end
	end)
end