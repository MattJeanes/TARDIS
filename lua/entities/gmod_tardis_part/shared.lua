ENT.Type = "anim"
if WireLib then
    ENT.Base            = "base_wire_entity"
else
    ENT.Base            = "base_gmodentity"
end
ENT.PrintName       = "TARDIS Part"
ENT.Author          = "Dr. Matt"
ENT.Spawnable       = false
ENT.AdminSpawnable  = false
ENT.Category        = "Doctor Who"
ENT.TardisPart      = true
ENT.AllowedProperties = {
    ["skin"] = true,
    ["bodygroups"] = true
}

function ENT:Initialize() end

function ENT:SetupDataTables()
    self:NetworkVar("Bool",0,"On")
    self:SetOn(self.EnabledOnStart or false)
end

hook.Add("PhysgunPickup", "tardis-part", function(ply,ent)
    if ent.TardisPart then return false end
end)

hook.Add("PlayerUnfrozeObject", "tardis-part", function(ply,ent,phys)
    if ent.TardisPart then phys:EnableMotion(false) end
end)

hook.Add("CanProperty", "tardis-part", function(ply,prop,ent)
    if ent.TardisPart and (not ent.AllowedProperties[prop]) then return false end
end)

hook.Add("CanDrive", "tardis-part", function(ply,ent)
    if ent.TardisPart then return false end
end)

function ENT:SetData(k,v,network)
    return IsValid(self.exterior) and self.exterior:SetData(k, v, network)
end

function ENT:GetData(k,default)
    return IsValid(self.exterior) and self.exterior:GetData(k, default)
end

hook.Add("BodygroupChanged", "tardis_parts", function(ent,bodygroup,value)
    if ent.TardisPart then
        if ent.OnBodygroupChanged then
            ent.OnBodygroupChanged(ent, bodygroup, value)
        end
        if IsValid(ent.parent) then
            ent.parent:CallHook("PartBodygroupChanged", ent, bodygroup, value)
        end
    end
end)

function ENT:SetVisible(visible)
    return self.parent:SetPartVisible(self.ID, visible)
end
