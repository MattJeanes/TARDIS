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
            TARDIS:Message(ply, "Doors is not installed!")
			ply:SendLua('TARDIS:ShowDoorsPopup()')
			return
		end
	end
end

ENT:AddHook("CustomData", "metadata", function(self, customData)
	if customData.metadataID then
		self.metadataID = customData.metadataID
	end
end)

function ENT:Initialize()
	if not self.metadataID then
		self.metadataID = TARDIS:GetSetting("interior","default",self:GetCreator())
	end
	self.metadata=TARDIS:GetInterior(self.metadataID)
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
	if self:CallHook("ShouldTakeDamage",dmginfo)==false then return end
	self:CallHook("OnTakeDamage", dmginfo)
end