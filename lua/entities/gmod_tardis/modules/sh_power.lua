-- Power Exterior

TARDIS:AddControl({
	id = "power",
	ext_func=function(self,ply)
		if self:TogglePower() then
			TARDIS:StatusMessage(ply, "Power", self:GetData("power-state"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle power")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Power",
		pressed_state_from_interior = false,
		pressed_state_data = "power-state",
		order = 2,
	},
	tip_text = "Power Switch",
})

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
		if (self:CallHook("CanTogglePower")==false or self.interior:CallHook("CanTogglePower")==false) then return false end
		self:SetData("power-state",on,true)
		self:CallHook("PowerToggled",on)
		if self.interior then
			self.interior:CallHook("PowerToggled",on)
		end
		return true
	end

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
else
	ENT:AddHook("ShouldNotDrawProjectedLight", "power", function(self)
		if not self:GetPower() then return true end
	end)

	ENT:AddHook("ShouldTurnOffLight", "power", function(self)
		if not self:GetPower() then return true end
	end)
end