function TARDIS:ClearExteriorMetadata(id)
    self.ExteriorsMetadata[id] = nil
    for k,v in pairs(self.ExteriorsMetadataRaw) do
        if v.Base == id then
            self:ClearExteriorMetadata(k)
        end
    end

    for k,v in pairs(self.ExteriorCategories) do
        if v[id] then
            v[id] = nil
        end
    end
end

function TARDIS:AddExterior(t)
    local id = t.ID
    t.Category = t.Category or "Miscellaneous"

    self:ClearExteriorMetadata(id)
    self.ExteriorsMetadataRaw[id] = t

    self.ExteriorCategories[t.Category] = self.ExteriorCategories[t.Category] or {}
    self.ExteriorCategories[t.Category][id] = true
end

function TARDIS:ImportExterior(int_id, ext_id, category, name, base, modify_func)
    if base == nil then base = "base" end

    local T = self:GetInterior(int_id)
    if not T or not T.Exterior then return false end

    local E = self:CopyTable(T.Exterior)
    E.ID = ext_id or int_id
    E.Base = base
    E.Name = name or T.Name or ext_id

    if category then
        E.Category = category
    end

    if modify_func then
        E = modify_func(E) or E
    end

    self:AddExterior(E)

    return true
end

function TARDIS:MergeExteriorMetadata(base, t)
    local copy=table.Copy(base)
    self:PreMergeExteriorMetadata(t)
    table.Merge(copy,t)
    self:PostMergeExteriorMetadata(copy)
    return copy
end

function TARDIS:SetupExteriorMetadata(id)
    if self.ExteriorsMetadata[id] then return end
    local t = self.ExteriorsMetadataRaw[id]
    if not t then return end

    local base = t.Base

    if base == true then
        self.ExteriorsMetadata[id] = t
        return
    end

    self:SetupExteriorMetadata(base)

    local m_base = self.ExteriorsMetadata[base]
    if not m_base then return end

    self.ExteriorsMetadata[id] = self:MergeExteriorMetadata(m_base, t)
end

function TARDIS:CreateExteriorMetadata(id)
    self:SetupExteriorMetadata(id)

    if self.ExteriorsMetadata[id] == nil then
        return self:CreateExteriorMetadata("default")
    end

    local metadata = TARDIS:CopyTable(self.ExteriorsMetadata[id])
    metadata.TextureSets = TARDIS:GetMergedTextureSets(metadata.TextureSets)

    return metadata
end

function TARDIS:GetExteriors()
    return self.ExteriorsMetadataRaw
end

function TARDIS:GetExteriorCategories()
    return self.ExteriorCategories
end

TARDIS:AddExterior({
	ID = "original",
	Name = "Original (no disguise)",
	Base = "base",
})

