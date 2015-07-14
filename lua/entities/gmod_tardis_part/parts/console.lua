-- The console

local PART={}
PART.ID = "console"
PART.Name = "The Console"
PART.AutoSetup = true
PART.Collision = true

if SERVER then	
	function PART:Use(ply)
		if ply:IsPlayer() and (not ply:GetTardisData("thirdperson")) and CurTime()>ply:GetTardisData("thirdpersoncool", 0) then
			self.exterior:PlayerThirdPerson(ply,true)
		end
	end
end

ENT:AddPart(PART,e)