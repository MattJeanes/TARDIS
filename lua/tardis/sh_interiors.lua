-- Interiors

TARDIS.Metadata = {}
TARDIS.MetadataRaw = {}
TARDIS.MetadataTemplates = {}

function TARDIS:FullReloadInteriors()
    self.Metadata = {}
    self.MetadataRaw = {}
    self.MetadataTemplates = {}
    TARDIS:LoadFolder("interiors/templates", nil, true)
    TARDIS:LoadFolder("interiors", nil, true)
    TARDIS:LoadFolder("interiors/versions", nil, true)
    TARDIS:MergeTemplates()
    TARDIS:MergeTextureSets()
end

function TARDIS:MergeMetadata(base, t)
    local copy=table.Copy(base)
    table.Merge(copy,t)
    return copy
end

function TARDIS:AddInterior(t)
    local id = t.ID

    if not t.NoFullReload and (self.Metadata[id] ~= nil or self.MetadataRaw[id] ~= nil) then
        TARDIS:FullReloadInteriors()
        return
    end

    self.Metadata[id] = t
    self.MetadataRaw[id] = t
    if t.Base and self.Metadata[t.Base] then
        self.Metadata[id] = TARDIS:MergeMetadata(TARDIS.Metadata[t.Base], t)
        self.Metadata[id].Versions = self.MetadataRaw[id].Versions
    end
    for k,v in pairs(self.MetadataRaw) do
        if id == v.Base then
            self.Metadata[k] = TARDIS:MergeMetadata(TARDIS.Metadata[v.Base], v)
            self.Metadata[k].Versions = self.MetadataRaw[k].Versions
        end
    end

    TARDIS:InitializeVersions(t)
    TARDIS:SetupSpawnmenuIcon(t)
end

function TARDIS:GetInterior(id, ent)
    if self.Metadata[id] == nil then return end

    if not ent then
        return self.Metadata[id]
    end

    local merged_metadata = TARDIS:MergeInteriorTemplates(self.Metadata[id], true, ent)
    return merged_metadata
end

function TARDIS:GetInteriors()
    return self.Metadata
end

TARDIS:LoadFolder("interiors/modules")
TARDIS:FullReloadInteriors()
