-- TARDIS debug pointer
-- Creators: Brundoob, Parar020100 and RyanM2711

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel(self.model or "models/brundoob/precision.mdl" )
	self:SetModelScale(self.scale or 1)

	self:PhysicsInit( MOVETYPE_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetUnFreezable(true)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if activator:GetTardisData("interior") then
		local pos,ang = TARDIS:GetLocalPos(self, activator)
		local decimals = 3
		local text =   "  Vector("..math.Round(pos.x,decimals)..", "..math.Round(pos.y,decimals)..", "..math.Round(pos.z,decimals).."),"
		text = text .. "  Angle("..math.Round(ang.p,decimals)..", "..math.Round(ang.y,decimals)..", "..math.Round(ang.r,decimals)..")"
		activator:ChatPrint(" \nCurrent pointer position:")
		activator:ChatPrint(text)
	end
	return
end
 
function ENT:Think()
end