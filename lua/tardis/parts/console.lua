-- The console

local PART={}
PART.ID = "console"
PART.Name = "The Console"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = true

if SERVER then	
	function PART:Use(ply)
		if ply:IsPlayer() and (not ply:GetTardisData("thirdperson")) and CurTime()>ply:GetTardisData("outsidecool", 0) then
			TARDIS:Control("thirdperson", ply)
		end
	end
end

TARDIS:AddPart(PART)