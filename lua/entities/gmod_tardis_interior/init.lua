AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
	net.WriteString(self.interior.ID)
end)

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
	self:SendData(ply)
end)

function ENT:Initialize()
	if self.spacecheck then
		self.interior=self:GetInterior(TARDIS:GetSetting("interior","default",self:GetCreator()))
		if not self.interior then
			self.interior=self:GetInterior("default")
		end
		
		self.Model=self.interior.Model
		self.Fallback=self.interior.Fallback
		self.Portals[2]=self.interior.Portal
	end
	self.BaseClass.Initialize(self)
end