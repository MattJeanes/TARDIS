AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	local ang=Angle(0, (ply:GetPos()-SpawnPos):Angle().y, 0)
	ent:SetAngles( ang )
	ent.owner=ply
	ent:Spawn()
	ent:Activate()
	return ent
end
 
function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/newexterior.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetUseType( SIMPLE_USE )
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:Wake()
	end
	
	self.occupants={}
	
	self:CallHook("Initialize")
end

function ENT:Think()
	for k,v in pairs(self.occupants) do
		if not v or not IsValid(v) then
			self.occupants[k]=nil
		end
	end
	
	self:CallHook("Think")
end