ENT:AddHook("OnTakeDamage", "hads", function(self)
	if (self:GetData("hads",false)==true and self:GetData("hads-triggered",false)==false) and (not self:GetData("teleport",false)) then
		self:GetCreator():ChatPrint("Your TARDIS is under attack and the HADS has been triggered!")
		self:SetData("hads-triggered",true,true)
		self:Demat()
		self:CallHook("HADSTrigger")
	end
end)
