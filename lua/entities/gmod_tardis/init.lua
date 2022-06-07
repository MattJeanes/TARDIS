AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    net.WriteString(self:GetID())
end)

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
    self:SendData(ply)
end)

if not TARDIS.DoorsFound then
    function ENT:SpawnFunction(ply,...)
        if not scripted_ents.GetStored(self.Base) then
            TARDIS:ErrorMessage(ply, "Doors is not installed!")
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
    self.metadata=TARDIS:GetInterior(self.metadataID, self)
    if not self.metadata then
        self.metadata=TARDIS:GetInterior("default", self)
    end

    self.Model=self:GetMetadata().Exterior.Model
    self.Portal=self:GetMetadata().Exterior.Portal
    self.Fallback=self:GetMetadata().Exterior.Fallback
    self.BaseClass.Initialize(self)
end

function ENT:PhysicsCollide(colData, collider)
    self:CallHook("PhysicsCollide", colData, collider)
end
function ENT:OnTakeDamage(dmginfo)
    if self:CallHook("ShouldTakeDamage",dmginfo)==false then return end
    self:CallHook("OnTakeDamage", dmginfo)
end