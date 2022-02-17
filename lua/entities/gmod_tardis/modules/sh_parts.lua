-- Parts

ENT:AddHook("Initialize","parts",function(self)
    if SERVER then
        TARDIS:SetupParts(self)
    elseif self.partqueue then
        for k,v in pairs(self.partqueue) do
            TARDIS:SetupPart(k,v,self,self.interior,self)
        end
    end
end)

function ENT:GetPart(id)
    return self.parts and self.parts[id] or NULL
end