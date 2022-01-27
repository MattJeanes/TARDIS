-- Power Interior

function ENT:GetPower()
	return self.exterior:GetPower()
end

ENT:AddHook("CanUseTardisControl", "power", function(self, control_id, ply)
	if not self:GetPower() and not TARDIS:GetControl(control_id).power_independent then
		TARDIS:ErrorMessage(ply, "Power is disabled. This doesn't work.")
		return false
	end
end)

if SERVER then
	function ENT:TogglePower()
		self.exterior:TogglePower()
	end

	function ENT:SetPower(on)
		self.exterior:SetPower(on)
	end

	ENT:AddHook("PowerToggled", "interior-power", function(self, state)
		self:SendMessage("power-toggled", function()
			net.WriteBool(state)
		end)
	end)
else
	ENT:OnMessage("power-toggled", function(self)
		local state = net.ReadBool()
		if TARDIS:GetSetting("sound") then
			local sound_on = self.metadata.Interior.Sounds.Power.On
			local sound_off = self.metadata.Interior.Sounds.Power.Off
			if TARDIS:GetExteriorEnt() == self.exterior then
				if not TARDIS:GetSetting("sound") then return end
				self:EmitSound(state and sound_on or sound_off)
			end
			if self.idlesounds then
				if state == false then
					for _,v in pairs(self.idlesounds) do
						v:Stop()
					end
				else
					for _,v in pairs(self.idlesounds) do
						v:Play()
					end
				end
			end
		end
	end)

	ENT:AddHook("ShouldNotDrawScreen", "power", function(self)
		if not self:GetPower() then
			return true
		end
	end)

	ENT:AddHook("ShouldDrawBlackScreen", "power", function(self)
		if not self:GetPower() then
			return true
		end
	end)

	ENT:AddHook("ShouldDrawLight", "power", function(self,id,light)
		if (not self:GetPower()) and ((not light) or (not light.nopower))  then
			return false
		end
	end)

	ENT:AddHook("ShouldDrawLight", "interior-lights-blinking", function(self)
		if self.exterior:GetData("interior-lights-blinking") then
			return (math.Round(8 * CurTime()) % 2 ~= 0)
		end
	end)

end