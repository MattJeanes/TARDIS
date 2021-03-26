-- Flight

-- Binds
TARDIS:AddKeyBind("flight-toggle",{
	name="Toggle Flight",
	section="Third Person",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			self:ToggleFlight()
		end
	end,
	key=KEY_R,
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
	desc="Hold this key while flying to speed up",
	key=KEY_LSHIFT,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("flight-rotate",{
	name="Rotate",
	section="Flight",
	desc="Hold this key while using left and right to rotate",
	key=KEY_LALT,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("flight-spindir",{
	name="Spin Direction",
	section="Flight",
	desc="Changes which way the TARDIS rotates while flying",
	func=function(self,down,ply)
		if TARDIS:HUDScreenOpen(ply) then return end
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
            TARDIS:Message(ply, "Spin direction set to "..dir)
		end
	end,
	key=MOUSE_RIGHT,
	serveronly=true,
	exterior=true
})

TARDIS:AddControl({
	id = "flight",
	ext_func=function(self,ply)
		if self:ToggleFlight() then
			TARDIS:StatusMessage(ply, "Flight mode", self:GetData("flight"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle flight mode")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Flight Mode",
		pressed_state_from_interior = false,
		pressed_state_data = "flight",
		order = 10,
	},
	tip_text = "Flight Mode"
})

if SERVER then	
	function ENT:ToggleFlight()
		local on = not self:GetData("flight",false)
		return self:SetFlight(on)
	end
	
	function ENT:SetFlight(on)
		if not on and self:CallHook("CanTurnOffFlight")==false then
			return false
		end
		if on and self:CallHook("CanTurnOnFlight")==false then
			return false
		end
		if on and self:GetData("physlock",false)==true then
			local pilot = self:GetData("pilot",nil)
			if IsValid(pilot) and pilot:IsPlayer() then
                TARDIS:Message(pilot, "WARNING: Physical lock engaged")
			end
		end
		self:SetData("flight",on,true)
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
                TARDIS:Message(ply, self.pilot:Nick().." is the pilot.")
			elseif self:CallHook("CanChangePilot",ply)~=false then
				self.pilot=ply
                TARDIS:Message(ply, "You are now the pilot.")
				self:CallHook("PilotChanged",nil,ply)
			end
		else
			local waspilot=self.pilot==ply
			if IsValid(self.pilot) and waspilot then
				self.pilot=nil
				for k,v in pairs(self.occupants) do
					if k:GetTardisData("thirdperson") then
						if IsValid(self.pilot) then
                            TARDIS:Message(k, self.pilot:Nick().." is now the pilot.")
						else
							self.pilot=k
                            TARDIS:Message(k, "You are now the pilot.")
						end
					end
				end
			end
			if waspilot then
				if IsValid(self.pilot) then
                    TARDIS:Message(ply, self.pilot:Nick().." is now the pilot.")
				else
                    TARDIS:Message(ply, "You are no longer the pilot.")
				end
				self:CallHook("PilotChanged",ply,self.pilot)
			end
		end
	end)
	
	ENT:AddHook("PilotChanged","flight",function(self,old,new)
		self:SetData("pilot",new,true)
		self:SendMessage("PilotChanged",function()
			net.WriteEntity(old)
			net.WriteEntity(new)
		end)
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
			local control=self:CallHook("FlightControl")~=false
			
			if self.pilot and IsValid(self.pilot) and control then
				local p=self.pilot
				local eye=p:GetTardisData("viewang")
				if not eye then
					eye=angle_zero
				end
				local fwd=eye:Forward()
				local ri=eye:Right()
				
				if TARDIS:IsBindDown(self.pilot,"flight-boost") then
					force=force*2.5
					vforce=vforce*2.5
					rforce=rforce*2.5
					tilt=5
				end
				if TARDIS:IsBindDown(self.pilot,"flight-forward") then
					ph:AddVelocity(fwd*force*phm)
					tilt=tilt+5
				end
				if TARDIS:IsBindDown(self.pilot,"flight-backward") then
					ph:AddVelocity(-fwd*force*phm)
					tilt=tilt+5
				end
				if TARDIS:IsBindDown(self.pilot,"flight-right") then
					if TARDIS:IsBindDown(self.pilot,"flight-rotate") then
						ph:AddAngleVelocity(Vector(0,0,-rforce))
					else
						ph:AddVelocity(ri*force*phm)
						tilt=tilt+5
					end
				end
				if TARDIS:IsBindDown(self.pilot,"flight-left") then
					if TARDIS:IsBindDown(self.pilot,"flight-rotate") then
						ph:AddAngleVelocity(Vector(0,0,rforce))
					else
						ph:AddVelocity(-ri*force*phm)
						tilt=tilt+5
					end
				end
				
				if TARDIS:IsBindDown(self.pilot,"flight-down") then
					ph:AddVelocity(-up*vforce*phm)
				elseif TARDIS:IsBindDown(self.pilot,"flight-up") then
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
			self.spindir = spindir
			return self.spindir
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
else
	TARDIS:AddSetting({
		id="flight-externalsound",
		name="External Sound",
		section="Flight",
		desc="Whether the flight sound can be heard on the outside or not",
		value=true,
		type="bool",
		option=true
	})
	
	ENT:AddHook("OnRemove", "flight", function(self)
		if self.flightsound then
			self.flightsound:Stop()
			self.flightsound=nil
		end
	end)
	
	ENT:AddHook("Think", "flight", function(self)
		if self:GetData("flight") and TARDIS:GetSetting("flight-externalsound") and TARDIS:GetSetting("sound") and (not self:CallHook("ShouldTurnOffFlightSound")) then
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
			else
				self.flightsound=CreateSound(self, self.metadata.Exterior.Sounds.FlightLoop)
				self.flightsound:SetSoundLevel(90)
				self.flightsound:Play()
			end
		elseif self.flightsound then
			self.flightsound:Stop()
			self.flightsound=nil
		end
	end)
	
	ENT:OnMessage("PilotChanged",function(self)
		local old=net.ReadEntity()
		local new=net.ReadEntity()
		self:CallHook("PilotChanged",old,new)
	end)
end