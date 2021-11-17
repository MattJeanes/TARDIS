-- Power Exterior

ENT:AddHook("Initialize","power-init", function(self)
	self:SetData("power-state",true,true)
end)

function ENT:GetPower()
	return self:GetData("power-state", false)
end

ENT:AddHook("CanUseTardisControl", "power", function(self, control_id, ply)
	if not self:GetPower() and not TARDIS:GetControl(control_id).power_independent then
		TARDIS:ErrorMessage(ply, "Power is disabled. This doesn't work.")
		return false
	end
end)

if SERVER then
	function ENT:TogglePower()
		return self:SetPower(not self:GetPower())
	end
	function ENT:SetPower(on)
		if (self:CallHook("CanTogglePower")==false or self.interior:CallHook("CanTogglePower")==false) then return false end
		self:SetData("power-state",on,true)
		self:CallHook("PowerToggled",on)
		if self.interior then
			self.interior:CallHook("PowerToggled",on)
		end
		return true
	end

	ENT:AddHook("CanTogglePower", "vortex", function(self)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false
		end
	end)

	ENT:AddHook("CanTriggerHads","power",function(self)
		if not self:GetPower() then return false end
	end)

	ENT:AddHook("HandleE2", "power", function(self,name,e2)
		if name == "Power" and TARDIS:CheckPP(e2.player, self) then
			return self:TogglePower() and 1 or 0
		elseif name == "GetPowered" then
			return self:GetPower() and 1 or 0
		end
	end)

	ENT:AddHook("CanToggleCloak", "power", function(self)
		if not self:GetPower() and not self:GetCloak() then 
			return false 
		end
	end)
else
	ENT:AddHook("ShouldNotDrawProjectedLight", "power", function(self)
		if not self:GetPower() then return true end
	end)

	ENT:AddHook("ShouldTurnOffLight", "power", function(self)
		if not self:GetPower() then return true end
	end)
end