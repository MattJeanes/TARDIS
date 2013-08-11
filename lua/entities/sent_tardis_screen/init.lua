AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/screen.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetColor(Color(255,255,255,255))
	self.phys = self:GetPhysicsObject()
	self:SetNWEntity("TARDIS",self.tardis)
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
end

function ENT:Use( activator, caller, type, value )

	if ( !activator:IsPlayer() ) then return end		-- Who the frig is pressing this shit!?
	
	if IsValid(self.interior.skycamera) and CurTime()>self.interior.skycamera.usecur then
		local skycamera=self.interior.skycamera
		skycamera.usecur=CurTime()+1
		skycamera:PlayerEnter(activator)
		local interior=self.interior
		if IsValid(interior) then
			if self.advanced then
				if interior.flightmode==1 and interior.step==1 then
					interior:UpdateAdv(activator,true)
				else
					interior:UpdateAdv(activator,false)
				end
			end
		end
	end
	
	self:NextThink( CurTime() )
	return true
end