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
	self:SetModel( "models/drmatt/tardis/newinterior.mdl" )
	self:SetMaterial("models/debug/debugwhite")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end	
	
	if not (self.exterior and IsValid(self.exterior)) then
		ErrorNoHalt("Exterior not set, removing!\n")
		self:Remove()
	end
	
	self:CallHook("Initialize")
end

function ENT:OnRemove()
	self:CallHook("OnRemove")
end