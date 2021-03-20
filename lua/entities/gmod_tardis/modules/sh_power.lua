-- Power Exterior

TARDIS:AddControl("power",{
	func=function(self,ply)
		self:TogglePower()
	end,
	interior=true,
	serveronly=true
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

	ENT:AddHook("SetupVirtualConsole", "power", function(self,frame,screen)
		local power = TardisScreenButton:new(frame,screen)
		power:Setup({
			id = "power",
			toggle = true,
			frame_type = {2, 1},
			text = "Toggle power",
			control = "power",
			pressed_state_source = self,
			pressed_state_data = "power-state",
			order = 2,
		})
	end)
end