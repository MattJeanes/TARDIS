-- Third person

ENT:AddHook("Use", "thirdperson", function(self,ply)
	if IsValid(ply) and ply:IsPlayer() and self.occupants[ply] and ply:KeyDown(IN_WALK) and not ply:GetTardisData("thirdperson") and CurTime()>ply:GetTardisData("thirdpersoncool", 0) then
		self.exterior:PlayerThirdPerson(ply,true)
	end
end)