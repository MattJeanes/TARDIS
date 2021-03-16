-- Hostile Action Displacement System

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
		self:GetCreator():ChatPrint("Your TARDIS is under attack and the HADS has been triggered!")
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
	elseif name == "HADS" then
		return self:ToggleHADS()
	end
end)