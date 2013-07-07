AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDIS-SetViewmode")
 
function ENT:Initialize()
	self:SetModel( "models/The_Sniper_9/DoctorWho/Tardis/tardisinteriorsmith.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
end

function ENT:Use( ply )
	if self.tardis and IsValid(self.tardis) and self.tardis.occupants then
		for k,v in pairs(self.tardis.occupants) do
			if v==ply and ply.tardis_viewmode then
				local pos=Vector(335, 310, 120)
				local pos2=self:WorldToLocal(ply:GetPos())
				local distance=pos:Distance(pos2)
				if distance < 25 then
					self.tardis:PlayerExit(ply,true)
					self.tardis.exitcur=CurTime()+1
				end
			end
		end
	end
end

function ENT:Think()
	if self.tardis and IsValid(self.tardis) and self.tardis.occupants then
		for k,v in pairs(self.tardis.occupants) do
			if self:GetPos():Distance(v:GetPos()) > 700 and v.tardis_viewmode then
				self.tardis:ToggleViewmode(v,true)
			end
		end
	end
end