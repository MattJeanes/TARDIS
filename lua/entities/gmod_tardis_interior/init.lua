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
	ent:SetCreator( ply )
	ent:Spawn()
	ent:Activate()
	return ent
end
 
function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/2012interior/interior.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetUseType( SIMPLE_USE )
	self:DrawShadow(false)
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end	
	
	if not (self.exterior and IsValid(self.exterior)) then
		ErrorNoHalt("Exterior not set, removing!\n")
		self:Remove()
	end
	
	self.occupants = {}
	
	self:CallHook("Initialize")
end

function ENT:Think()
	for k,v in pairs(self.occupants) do
		if not k or not IsValid(k) then
			self.occupants[k]=nil
		end
	end
	self:CallHook("Think")
end