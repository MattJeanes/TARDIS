-- Hostile Action Displacement System

TARDIS:AddControl({
	id = "hads",
	ext_func=function(self,ply)
		TARDIS:StatusMessage(ply, "Hostile Action Displacement System", self:ToggleHADS())
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "H.A.D.S.",
		pressed_state_from_interior = false,
		pressed_state_data = "hads",
		order = 13,
	},
	tip_text = "H.A.D.S.",
})

if SERVER then
	function ENT:SetHADS(on)
		return self:SetData("hads",on,true)
	end

	function ENT:ToggleHADS()
		local on = not self:GetData("hads",false)
		return self:SetHADS(on)
	end

	ENT:AddHook("OnTakeDamage", "hads", function(self)
		if self:CallHook("CanTriggerHads")==false then return end
		if (self:GetData("hads",false)==true and self:GetData("hads-triggered",false)==false) and (not self:GetData("teleport",false)) then
            TARDIS:Message(self:GetCreator(), "Your TARDIS is under attack and the HADS has been triggered!")
			self:SetData("hads-triggered",true,true)
			self:SetFastRemat(false)
			self:Demat()
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