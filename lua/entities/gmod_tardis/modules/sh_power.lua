-- Power Exterior

ENT:AddHook("Initialize","power-init", function(self)
	self:SetData("power-state",true,true)
end)

ENT:AddHook("Initialize", "screens-toggle-init", function(self)
	self:SetData("screens_on", true, true)
end)

function ENT:SetScreensOn(on)
	self:SetData("screens_on", on, true)
	return true
end
function ENT:ToggleScreens()
	self:SetScreensOn(not self:GetData("screens_on", false))
	return true
end

if SERVER then
	function ENT:TogglePower()
		local on = not self:GetData("power-state",false)
		self:SetPower(on)
	end
	function ENT:SetPower(on)
		if (self:CallHook("CanTogglePower")==false or self.interior:CallHook("CanTogglePower")==false) then return end
		self:SetData("power-state",on,true)
		self:CallHook("PowerToggled",on)
		if self.interior then
			self.interior:CallHook("PowerToggled",on)
		end
	end

	ENT:AddHook("CanTriggerHads","power",function(self)
		if not self:GetData("power-state",false) then return false end
	end)
else
	ENT:AddHook("ShouldNotDrawProjectedLight", "power", function(self)
		if not self:GetData("power-state") then return true end
	end)
end