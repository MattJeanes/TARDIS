AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
	net.WriteString(self.metadata.ID)
end)

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
	self:SendData(ply)
end)

if not TARDIS.DoorsFound then
	function ENT:SpawnFunction(ply,...)
		if not scripted_ents.GetStored(self.Base) then
			ply:ChatPrint("Doors is not installed!")
			ply:SendLua('TARDIS:ShowDoorsPopup()')
			return
		end
	end
end

function ENT:Initialize()
	self.metadata=TARDIS:GetInterior(TARDIS:GetSetting("interior","default",self:GetCreator()))
	if not self.metadata then
		self.metadata=TARDIS:GetInterior("default")
	end
	self.Model=self.metadata.Exterior.Model
	self.Portal=self.metadata.Exterior.Portal
	self.Fallback=self.metadata.Exterior.Fallback
	self.BaseClass.Initialize(self)
end

function ENT:PhysicsCollide(colData, collider)
	self:CallHook("PhysicsCollide", colData, collider)
end
function ENT:OnTakeDamage(dmginfo)
	self:CallHook("OnTakeDamage", dmginfo)
end