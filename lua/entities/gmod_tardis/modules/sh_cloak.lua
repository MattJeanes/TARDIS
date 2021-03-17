--Placeholder cloak module (currently only for E2, feel free to delete later)

ENT:AddHook("HandleE2", "cloak", function(self,name,e2)
	if name == "Phase" and TARDIS:CheckPP(e2.player, self) then
		return 0
	elseif name == "GetVisible" then
		return 0
	end
end)