-- Float

TARDIS:AddControl({
	id = "float",
	ext_func=function(self,ply)
		if self:ToggleFloat() then
			TARDIS:StatusMessage(ply, "Anti-gravs", self:GetData("float"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle anti-gravs")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Anti-Gravs",
		pressed_state_from_interior = false,
		pressed_state_data = "float",
		order = 11,
	},
	tip_text = "Anti-Gravs",
})

-- Binds
TARDIS:AddKeyBind("float-toggle",{
	name="Float Toggle",
	section="Third Person",
	desc="Lets the TARDIS fly as if there is no gravity",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			if self:ToggleFloat() then
                TARDIS:Message(ply, "Float "..(self:GetData("floatfirst") and "en" or "dis").."abled")
			end
		end
	end,
	key=KEY_T,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-forward",{
	name="Forward",
	section="Float",
	key=KEY_W,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-backward",{
	name="Backward",
	section="Float",
	key=KEY_S,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-left",{
	name="Left",
	section="Float",
	key=KEY_A,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-right",{
	name="Right",
	section="Float",
	key=KEY_D,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-boost",{
	name="Boost",
	section="Float",
	desc="Hold this key while floating to speed up rotation",
	key=KEY_LSHIFT,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-rotate",{
	name="Rotate",
	section="Float",
	desc="Hold this key while using left and right to rotate on yaw axis",
	key=KEY_LALT,
	serveronly=true,
	exterior=true
})
TARDIS:AddKeyBind("float-brake",{
	name="Brake",
	section="Float",
	desc="Hold this key to slow rotation in float mode",
	key=KEY_SPACE,
	serveronly=true,
	exterior=true
})

if SERVER then
	function ENT:SetFloat(on)
		if (not on) and self:CallHook("CanTurnOffFloat")==false then return end
		if (on) and self:CallHook("CanTurnOnFloat")==false then return end
		self:SetData("float",on,true)
		self.phys:EnableGravity(not on)
		return true
	end
	
	function ENT:ToggleFloat()
		local on=not self:GetData("float",false)
		if self:GetData("flight") then
			self:SetData("floatfirst",not self:GetData("floatfirst",false))
		else
			self:SetData("floatfirst",on)
		end
		return self:SetFloat(on)
	end
	
	ENT:AddHook("CanTurnOffFloat", "float", function(self)
		if self:GetData("floatfirst") then return false	end
	end)

	ENT:AddHook("CanTurnOnFloat", "float", function(self)
		if not self:GetPower() then return false end
	end)
	
	ENT:AddHook("Think", "float", function(self)
		if self:GetData("float") then
			self.phys:Wake()
		end
	end)
	
	ENT:AddHook("OnHealthDepleted","float",function(self)
		if self:GetData("float") and self:GetData("floatfirst") then
			self:ToggleFloat()
		end
	end)
	
	ENT:AddHook("PhysicsUpdate", "float", function(self,ph)
		if self:GetData("float") then
			if ph:IsGravityEnabled() then
				ph:AddVelocity(Vector(0,0,9.0135))
			end
			if (not self:GetData("flight")) and self.pilot and IsValid(self.pilot) then
				local p=self.pilot
				local eye=p:GetTardisData("viewang")
				if not eye then
					eye=angle_zero
				end
				local fwd=eye:Forward()
				local ri=eye:Right()
				local ang=self:WorldToLocalAngles(eye)
				
				local force=1
				local rforce=2
				local offset=-1*eye
				if TARDIS:IsBindDown(self.pilot,"float-boost") then
					force=force*2.5
					rforce=rforce*2.5
				end
				if TARDIS:IsBindDown(self.pilot,"float-forward") then
					local vec=Vector(0,force,0)
					vec:Rotate(ang)
					ph:AddAngleVelocity(vec)
				end
				if TARDIS:IsBindDown(self.pilot,"float-backward") then
					local vec=Vector(0,-force,0)
					vec:Rotate(ang)
					ph:AddAngleVelocity(vec)
				end
				if TARDIS:IsBindDown(self.pilot,"float-right") then
					if TARDIS:IsBindDown(self.pilot,"float-rotate") then
						local vec=Vector(0,0,-rforce)
						vec:Rotate(ang)
						ph:AddAngleVelocity(vec)
					else
						local vec=Vector(force,0,0)
						vec:Rotate(ang)
						ph:AddAngleVelocity(vec)
					end
				end
				if TARDIS:IsBindDown(self.pilot,"float-left") then
					if TARDIS:IsBindDown(self.pilot,"float-rotate") then
						local vec=Vector(0,0,rforce)
						vec:Rotate(ang)
						ph:AddAngleVelocity(vec)
					else
						local vec=Vector(-force,0,0)
						vec:Rotate(ang)
						ph:AddAngleVelocity(vec)
					end
				end
				
				if TARDIS:IsBindDown(self.pilot,"float-brake") then
					ph:AddAngleVelocity(ph:GetAngleVelocity()*-0.05)
				end
			end
		end
	end)
else
	ENT:AddHook("ShouldTurnOnLight", "float", function(self)
		if self:GetData("float") then return true end
	end)

	ENT:AddHook("ShouldPulseLight", "float", function(self)
		if self:GetData("float") then return true end
	end)
end