--Exterior security

ENT:AddHook("HandleE2", "security", function(self,name,e2)
	if IsValid(self.interior) then
		if name == "Isomorph" then
			return self.interior:ToggleSecurity() and 1 or 0
		elseif name == "GetIsomorphic" then
			return self.interior:GetSecurity() and 1 or 0
		end
	end
end)