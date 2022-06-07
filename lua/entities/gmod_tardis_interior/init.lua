AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    net.WriteString(self:GetID())
end)

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
    self:SendData(ply)
end)

function ENT:Initialize()
    if self.spacecheck then
        self.metadata=TARDIS:GetInterior(self.exterior.metadataID, self)
        if not self.metadata then
            self.metadata=TARDIS:GetInterior("default", self)
        end

        self.Model=self:GetIntMetadata().Model
        self.Fallback=self:GetIntMetadata().Fallback
        self.Portal=self:GetIntMetadata().Portal
        self.CustomPortals=self:GetIntMetadata().CustomPortals
        self.ExitDistance=self:GetIntMetadata().ExitDistance
    end
    self.BaseClass.Initialize(self)
end

function ENT:OnTakeDamage(dmginfo)
    if self:CallHook("ShouldTakeDamage",dmginfo)==false then return end
    self:CallHook("OnTakeDamage", dmginfo)
end