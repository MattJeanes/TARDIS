-- Cloisterbells
if CLIENT then
	TARDIS:AddSetting({
		id="cloistersound",
		name="Cloister bells",
		desc="Whether the warning bells can be heard on the interior or not",
		section="Sounds",
		value=true,
		type="bool",
		option=true
	})

	ENT:AddHook("OnRemove","Cloisters",function(self)
		if self.CloisterLoop then
			self.CloisterLoop:Stop()
			self.CloisterLoop = nil
		end
	end)

	ENT:AddHook("ShouldTurnOnCloisters","cloisters",function(self)
		return self:GetData("cloisters")
	end)

	ENT:AddHook("ShouldTurnOffCloisters","power",function(self)
		if not self:GetPower() then
			return true
		end
	end)

	ENT:AddHook("Think", "cloistersound", function(self)
		local shouldon=self:CallHook("ShouldTurnOnCloisters")
		local shouldoff=self:CallHook("ShouldTurnOffCloisters")
		local sound = self.metadata.Interior.Sounds.Cloister

		if TARDIS:GetSetting("cloistersound") and TARDIS:GetSetting("sound") then
			if shouldon and (not shouldoff) then
				if not self.CloisterLoop then
					self.CloisterLoop = CreateSound(self, sound)
				end
				self.CloisterLoop:Play()
			elseif self.CloisterLoop then
				self.CloisterLoop:Stop()
				self.CloisterLoop = nil
			end
		end
	end)
end

function ENT:SetCloisters(on)
	self:SetData("cloisters",on,true)
end

function ENT:ToggleCloisters()
	self:SetCloisters(not self:GetData("cloisters",false))
end

ENT:AddHook("HealthWarningToggled","cloisters",function(self, on)
	self:SetCloisters(on)
end)