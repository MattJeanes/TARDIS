-- The console

local PART={}
PART.ID = "console"
PART.Name = "The Console"
PART.Model = "models/drmatt/tardis/2012interior/console.mdl"
PART.AutoSetup = true
PART.Collision = true

if SERVER then
	function PART:Initialize()		
		local int=self.interior		
		self:SetPos(int:GetPos())
		self:SetAngles(int:GetAngles())
		self:SetParent(int)
	end
	
	function PART:Use(ply)
		if ply:IsPlayer() and (not ply:GetTardisData("thirdperson")) and CurTime()>ply:GetTardisData("thirdpersoncool", 0) then
			self.exterior:PlayerThirdPerson(ply,true)
		end
	end
end

ENT:AddPart(PART,e)