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
end

function TARDIS:MergeMetadata(base, t)
    local copy=table.Copy(base)
    table.Merge(copy,t)
    return copy
end

function TARDIS:AddInterior(t)
    if self.Metadata[t.ID] ~= nil and self.MetadataRaw[t.ID] ~= nil then
        TARDIS:FullReloadInteriors()
        return
    end

    self.Metadata[t.ID] = t
    self.MetadataRaw[t.ID] = t
    if t.Base and self.Metadata[t.Base] then
        self.Metadata[t.ID] = TARDIS:MergeMetadata(TARDIS.Metadata[t.Base], t)
        self.Metadata[t.ID].Versions = self.MetadataRaw[t.ID].Versions
    end
    for k,v in pairs(self.MetadataRaw) do
        if t.ID == v.Base then
            self.Metadata[k] = TARDIS:MergeMetadata(TARDIS.Metadata[v.Base], v)
            self.Metadata[k].Versions = self.MetadataRaw[k].Versions
        end
    end

    if t.Base ~= true and not t.Hidden and not t.IsVersionOf then
        TARDIS:InitializeVersions(t.ID)
        TARDIS:SetupSpawnmenuIcon(t)
    end
end

function TARDIS:GetInterior(id)
    if self.Metadata[id] ~= nil then
        return self.Metadata[id]
    end
end

function TARDIS:GetInteriors()
    return self.Metadata
end

TARDIS:LoadFolder("interiors/modules")
TARDIS:FullReloadInteriors()
