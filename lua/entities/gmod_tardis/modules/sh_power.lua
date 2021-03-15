-- Power Exterior

ENT:AddHook("Initialize","power-init", function(self)
	self:SetData("power-state",true,true)
end)

function ENT:GetPower()
	return self:GetData("power-state", false)
end

if SERVER then
	function ENT:TogglePower()
		return self:SetPower(not self:GetPower())
	end
	function ENT:SetPower(on)
		if (self:CallHook("CanTogglePower")==false or self.interior:CallHook("CanTogglePower")==false) then return end
		local success = self:SetData("power-state",on,true)
		self:CallHook("PowerToggled",on)
		if self.interior then
			self.interior:CallHook("PowerToggled",on)
		end
		return success
	end

	ENT:AddHook("CanTriggerHads","power",function(self)
		if not self:GetPower() then return false end
	end)

	ENT:AddHook("HandleE2", "power", function(self,name,e2)
		if name == "Power" then
			return self:TogglePower()
		elseif name == "GetPowered" then
			return self:GetPower() and 1 or 0
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