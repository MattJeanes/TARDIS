-- Hostile Action Displacement System

if SERVER then
	function ENT:SetHADS(on)
		return self:SetData("hads",on,true)
	end

	function ENT:ToggleHADS()
		local on = not self:GetData("hads",false)
		return self:SetHADS(on)
	end

	ENT:AddHook("OnTakeDamage", "hads", function(self)
		if self:CallHook("CanTriggerHads") == false then return end
		if (self:GetData("hads",false) == true and self:GetData("hads-triggered",false)==false) and (not self:GetData("teleport",false)) then
			if self:GetData("doorstatereal") then
				self:ToggleDoor()
			end
			if self:GetData("handbrake") then
				self:ToggleHandbrake()
			end
			if self:CallHook("CanDemat", true) == false then
				if not self:GetData("hads-failed-time") or CurTime() > self:GetData("hads-failed-time") + 10 then
					self:SetData("hads-failed-time", CurTime())
					TARDIS:ErrorMessage(self:GetCreator(), "Something stopped H.A.D.S. from dematerialising the TARDIS!")
					TARDIS:ErrorMessage(self:GetCreator(), "Your TARDIS is under attack!")
				end
				return
			end
			TARDIS:Message(self:GetCreator(), "H.A.D.S. has been triggered!")
			TARDIS:Message(self:GetCreator(), "Your TARDIS is under attack!")
			self:SetData("hads-triggered", true)
			self:SetFastRemat(false)
			self:AutoDemat()
			self:CallHook("HADSTrigger")
		end
	end)

	ENT:AddHook("StopDemat","hads",function(self)
		if self:GetData("hads-triggered",false) then
			self:SetData("hads-triggered",false,true)
		end
	end)

	ENT:AddHook("HandleE2", "hads", function(self,name,e2)
		if name == "GetHADS" then
			return self:GetData("hads",false) and 1 or 0
		elseif name == "HADS" and TARDIS:CheckPP(e2.player, self) then
			return self:ToggleHADS()
		end
	end)
end