AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    net.WriteString(self.metadata.ID)

    net.WriteBool(self.templates ~= nil)
    if self.templates ~= nil then
        net.WriteString(TARDIS.von.serialize(self.templates))
    end
end)

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
    self:SendData(ply)
end)

function ENT:Initialize()
    if not IsValid(self.exterior) then
        self:Remove()
        return
    end

    self.interior = self
    if self.spacecheck then
        self.metadata=TARDIS:CreateInteriorMetadata(self.exterior.metadataID, self)
        self.Model=self.metadata.Interior.Model
        self.Fallback=self.metadata.Interior.Fallback
        self.Portal=self.metadata.Interior.Portal
        self.CustomPortals=self.metadata.Interior.CustomPortals
        self.ExitDistance=self.metadata.Interior.ExitDistance
    end
    self.BaseClass.Initialize(self)
end

function ENT:OnTakeDamage(dmginfo)
    if self:CallHook("ShouldTakeDamage",dmginfo)==false then return end
    self:CallHook("OnTakeDamage", dmginfo)
end