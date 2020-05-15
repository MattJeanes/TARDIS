AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:OnTakeDamage(dmginfo)
	if self.parent:CallHook("ShouldTakeDamage",dmginfo)==false then return end
	self.parent:CallHook("OnTakeDamage", dmginfo)
end