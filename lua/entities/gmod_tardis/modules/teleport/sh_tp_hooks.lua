-- Teleport

if SERVER then

	ENT:AddHook("CanToggleDoor","teleport",function(self,state)
		if self:GetData("teleport") then
			return false
		end
	end)

	ENT:AddHook("ShouldThinkFast","teleport",function(self)
		if self:GetData("teleport") then
			return true
		end
	end)

	ENT:AddHook("CanPlayerEnter","teleport",function(self)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false, true
		end
	end)

	ENT:AddHook("CanPlayerEnterDoor","teleport",function(self)
		if (self:GetData("teleport") or self:GetData("vortex")) then
			return false
		end
	end)

	ENT:AddHook("CanPlayerExit","teleport",function(self)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false
		end
	end)

	ENT:AddHook("ShouldTurnOnRotorwash", "teleport", function(self)
		if self:GetData("teleport") then
			return true
		end
	end)

	ENT:AddHook("ShouldTurnOffRotorwash", "teleport", function(self)
		if self:GetData("vortex") then
			return true
		end
	end)

	ENT:AddHook("ShouldStopSmoke", "vortex", function(self)
		if self:GetData("vortex") then return true end
	end)

	ENT:AddHook("ShouldTakeDamage", "vortex", function(self)
		if self:GetData("vortex",false) then return false end
	end)

	ENT:AddHook("ShouldExteriorDoorCollide", "teleport", function(self,open)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false
		end
	end)

else

	ENT:AddHook("ShouldTurnOnLight","teleport",function(self)
		if self:GetData("teleport") then
			return true
		end
	end)

	ENT:AddHook("ShouldPulseLight","teleport",function(self)
		if self:GetData("teleport") then
			return true
		end
	end)

	ENT:AddHook("ShouldTurnOffFlightSound", "teleport", function(self)
		if self:GetData("teleport") or (self:GetData("vortex") and TARDIS:GetExteriorEnt() ~= self) then
			return true
		end
	end)

	ENT:AddHook("PilotChanged","teleport",function(self,old,new)
		if self:GetData("teleport-trace") then
			self:SetData("teleport-trace",false)
		end
	end)


end

