-- Parts

ENT:AddHook("Initialize","parts",function(self)
    if SERVER then
        TARDIS:SetupParts(self)
    elseif self.partqueue then
        for k,v in pairs(self.partqueue) do
            TARDIS:SetupPart(k,v,self.exterior,self,self)
        end
    end
end)

ENT:AddHook("Cordon","parts",function(self,class,ent)
    if ent.TardisPart then return false end
end)

if SERVER then
    ENT:AddHook("OnRemove","inside_entities",function(self)
        for i,v in ipairs(ents.FindInSphere(self:GetPos(), self.metadata.Interior.ExitDistance)) do
            local cl = v:GetClass()
            if cl ~= "gmod_tardis_interior"
                and cl ~= "linked_portal_door"
                and cl ~= "prop_vehicle_prisoner_pod"
                and cl ~= "base_cube_environment"
                and not string.StartsWith(cl, "gmod_tardis_part")
            then
                v:Remove()
            end
        end
    end)
end

function ENT:GetPart(id)
    return self.parts and self.parts[id] or NULL
end

function ENT:GetParts()
    return self.parts
end

if CLIENT then
    -- Special rendering for transparent parts

    ENT:AddHook("PostDrawTranslucentRenderables","parts",function(self)
        if self.parts then
            for _,part in pairs(self.parts) do
                if IsValid(part) and part.UseTransparencyFix then
                    TARDIS.DrawOverride(part,true)
                end
            end
        end
    end)
end
