ENT:AddHook("OnTakeDamage", "hads", function(self)
	if (self:GetData("hads",false) == true) and (not self:GetData("teleport",false)) then
		self:GetCreator():ChatPrint("Your TARDIS is under attack and the HADS has been triggered!")
		self:Demat()
		//self:DoHADSActions() 👀
	end
end)
