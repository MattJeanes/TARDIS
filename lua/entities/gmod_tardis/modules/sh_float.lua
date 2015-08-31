-- Float

-- Binds
TARDIS:AddKeyBind("float-toggle",{
	name="Float Toggle",
	section="Third Person",
	desc="Lets the TARDIS fly as if there is no gravity",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			self:ToggleFloat()
			ply:ChatPrint("Float "..(self:GetData("floatfirst") and "en" or "dis").."abled")
		end
	end,
	key=KEY_T,
	serveronly=true,
	exterior=true
})

if SERVER then
	function ENT:SetFloat(on)
		if (not on) and self:CallHook("CanTurnOffFloat")==false then return end
		self:SetData("float",on,true)
		self.phys:EnableGravity(not on)
		self:SetLight(on)
	end
	
	function ENT:ToggleFloat()
		local on=not self:GetData("float",false)
		if self:GetData("flight") then
			self:SetData("floatfirst",not self:GetData("floatfirst",false))
		else
			self:SetData("floatfirst",on)
		end
		self:SetFloat(on)
	end
	
	ENT:AddHook("CanTurnOffLight", "float", function(self)
		if self:GetData("float") then return false end
	end)
	
	ENT:AddHook("CanTurnOffFloat", "float", function(self)
		if self:GetData("floatfirst") then return false	end
	end)
	
	ENT:AddHook("Think", "float", function(self)
		if self:GetData("float") then
			self.phys:Wake()
		end
	end)
	
	ENT:AddHook("PhysicsUpdate", "float", function(self,ph)
		if self:GetData("float") then
			if ph:IsGravityEnabled() then
				ph:AddVelocity(Vector(0,0,9.0135))
			end
		end
	end)
end