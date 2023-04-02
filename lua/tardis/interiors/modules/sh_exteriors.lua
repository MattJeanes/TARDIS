function TARDIS:AddExterior(t)
    id = t.ID
    self.ExteriorsMetadataRaw[id] = t
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

TARDIS:AddExterior({
	ID = "original",
	Name = "Original (no disguise)",
	Base = "base",
})

TARDIS:LoadFolder("interiors/exteriors", nil, true)