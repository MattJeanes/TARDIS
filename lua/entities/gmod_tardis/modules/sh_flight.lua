-- Flight

-- Binds
ENT:AddKeyBind("flight-toggle",{
	name="Toggle",
	section="Flight",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			self:ToggleFlight()
		end
	end,
	key=KEY_R,
	serveronly=true
})
ENT:AddKeyBind("flight-forward",{
	name="Forward",
	section="Flight",
	key=KEY_W,
	serveronly=true
})
ENT:AddKeyBind("flight-backward",{
	name="Backward",
	section="Flight",
	key=KEY_S,
	serveronly=true
})
ENT:AddKeyBind("flight-left",{
	name="Left",
	section="Flight",
	key=KEY_A,
	serveronly=true
})
ENT:AddKeyBind("flight-right",{
	name="Right",
	section="Flight",
	key=KEY_D,
	serveronly=true
})
ENT:AddKeyBind("flight-up",{
	name="Up",
	section="Flight",
	key=KEY_SPACE,
	serveronly=true
})
ENT:AddKeyBind("flight-down",{
	name="Down",
	section="Flight",
	key=KEY_LCONTROL,
	serveronly=true
})
ENT:AddKeyBind("flight-boost",{
	name="Boost",
	section="Flight",
	desc="Hold this key while flying to speed up",
	key=KEY_LSHIFT,
	serveronly=true
})
ENT:AddKeyBind("flight-rotate",{
	name="Rotate",
	section="Flight",
	desc="Hold this key while using left and right to rotate",
	key=KEY_LALT,
	serveronly=true
})
ENT:AddKeyBind("flight-spindir",{
	name="Spin Direction",
	section="Flight",
	desc="Changes which way the TARDIS rotates while flying",
	func=function(self,down,ply)
		if down and ply==self.pilot then
			local dir
			if self.spindir==-1 then
				self.spindir=0
				dir="none"
			elseif self.spindir==0 then
				self.spindir=1
				dir="clockwise"
			elseif self.spindir==1 then
				self.spindir=-1
				dir="anti-clockwise"
			end
			ply:ChatPrint("Spin direction set to "..dir)
		end
	end,
	key=MOUSE_RIGHT,
	serveronly=true
})

if SERVER then
	function ENT:CreateRotorWash()
		if IsValid(self.rotorwash) then return end
		self.rotorwash = ents.Create("env_rotorwash_emitter")
		self.rotorwash:SetPos(self:GetPos())
		self.rotorwash:SetParent(self)
		self.rotorwash:Activate()
	end

	function ENT:RemoveRotorWash()
		if IsValid(self.rotorwash) then
			self.rotorwash:Remove()
			self.rotorwash=nil
		end
	end
	
	function ENT:ToggleFlight()
		local on=self:SetData("flight",not self:GetData("flight",false),true)
		self:SetFloat(on)
		if on then
			self:CreateRotorWash()
		else
			self:RemoveRotorWash()
		end
	end
	
	ENT:AddHook("CanTurnOffLight", "flight", function(self)
		if self:GetData("flight") then return false end
	end)
	
	ENT:AddHook("CanTurnOffFloat", "flight", function(self)
		if self:GetData("flight") then return false end
	end)
	
	ENT:AddHook("ThirdPerson", "flight", function(self,ply,enabled)
		if enabled then
			if IsValid(self.pilot) then
				ply:ChatPrint(self.pilot:Nick().." is the pilot.")
			else
				self.pilot=ply
				ply:ChatPrint("You are now the pilot.")
			end
		else
			local waspilot=self.pilot==ply
			if IsValid(self.pilot) and waspilot then
				self.pilot=nil
				for k,v in pairs(self.occupants) do
					if k:GetTardisData("thirdperson") then
						if IsValid(self.pilot) then
							k:ChatPrint(self.pilot:Nick().." is now the pilot.")
						else
							self.pilot=k
							k:ChatPrint("You are now the pilot.")
						end
					end
				end
			end
			if waspilot then
				if IsValid(self.pilot) then
					ply:ChatPrint(self.pilot:Nick().." is now the pilot.")
				else
					ply:ChatPrint("You are no longer the pilot.")
				end
			end
		end
	end)
	
	ENT:AddHook("Initialize", "flight", function(self)
		self.spindir=-1
	end)
	
	ENT:AddHook("Think", "flight", function(self)
		if self:GetData("flight") then
			self.phys:Wake()
		end
	end)
	
	ENT:AddHook("PhysicsUpdate", "flight", function(self,ph)
		local pos=self:GetPos()
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
			local tforce=400
			local tilt=0
			
			if self.pilot and IsValid(self.pilot) then
				local p=self.pilot
				local eye=p:GetTardisData("viewang")
				if not eye then
					eye=angle_zero
				end
				local fwd=eye:Forward()
				local ri=eye:Right()
				
				if self:IsBindDown(self.pilot,"flight-boost") then
					force=force*2.5
					vforce=vforce*2.5
					rforce=rforce*2.5
					tilt=5
				end
				if self:IsBindDown(self.pilot,"flight-forward") then
					ph:AddVelocity(fwd*force*phm)
					tilt=tilt+5
				end
				if self:IsBindDown(self.pilot,"flight-backward") then
					ph:AddVelocity(-fwd*force*phm)
					tilt=tilt+5
				end
				if self:IsBindDown(self.pilot,"flight-right") then
					if self:IsBindDown(self.pilot,"flight-rotate") then
						ph:AddAngleVelocity(Vector(0,0,-rforce))
					else
						ph:AddVelocity(ri*force*phm)
						tilt=tilt+5
					end
				end
				if self:IsBindDown(self.pilot,"flight-left") then
					if self:IsBindDown(self.pilot,"flight-rotate") then
						ph:AddAngleVelocity(Vector(0,0,rforce))
					else
						ph:AddVelocity(-ri*force*phm)
						tilt=tilt+5
					end
				end
				
				if self:IsBindDown(self.pilot,"flight-down") then
					ph:AddVelocity(-up*vforce*phm)
				elseif self:IsBindDown(self.pilot,"flight-up") then
					ph:AddVelocity(up*vforce*phm)
				end
			end
			
			if self.spindir==0 then
				tilt=0
			elseif self.spindir==1 then
				tforce=-tforce
			end
			
			ph:ApplyForceOffset( up*-ang.p,cen-fwd2*lev)
			ph:ApplyForceOffset(-up*-ang.p,cen+fwd2*lev)
			ph:ApplyForceOffset( up*-(ang.r-tilt),cen-ri2*lev)
			ph:ApplyForceOffset(-up*-(ang.r-tilt),cen+ri2*lev)
			
			if not (self.spindir==0) then
				local twist=Vector(0,0,vell/tforce)
				ph:AddAngleVelocity(twist)
			end
			local angbrake=angvel*-0.015
			ph:AddAngleVelocity(angbrake)
			local brake=vel*-0.01
			ph:AddVelocity(brake)
		end
	end)
else
	ENT:AddHook("OnRemove", "flight", function(self)
		if self.flightsound then
			self.flightsound:Stop()
			self.flightsound=nil
		end
	end)
	ENT:AddHook("Think", "flight", function(self)
		if self.flightsound and self.flightsound:IsPlaying() then
			local p=math.Clamp(self:GetVelocity():Length()/250,0,15)
			local ply=LocalPlayer()
			local e=ply:GetViewEntity()
			if not IsValid(e) then e=ply end
			if ply:GetTardisData("exterior")==self and e==self.thpprop and ply:GetTardisData("thirdperson") then
				self.flightsound:ChangePitch(95+p,0.1)
				self.flightsound:ChangeVolume(0.75,0)
			else
				local pos = e:GetPos()
				local spos = self:GetPos()
				local doppler = (pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200
				self.flightsound:ChangePitch(math.Clamp(95+p+doppler,80,120),0.1)
			end
		end
	end)
	ENT:AddHook("DataChanged", "flight", function(self,k,v)
		if k=="flight" then
			if v then
				if not self.flightsound then
					self.flightsound=CreateSound(self, "drmatt/tardis/flight_loop.wav")
					self.flightsound:SetSoundLevel(90)
					self.flightsound:Play()
				end
			else
				if self.flightsound then
					self.flightsound:Stop()
					self.flightsound=nil
				end
			end
		end
	end)
end