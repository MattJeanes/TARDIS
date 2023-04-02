-- Interiors

CreateConVar("tardis2_selected_interior", "", {FCVAR_REPLICATED}, "TARDIS - selected interior to spawn when not using the spawnmenu")

TARDIS.Metadata = {}
TARDIS.MetadataRaw = {}
TARDIS.MetadataTemplates = {}
TARDIS.MetadataVersions = {}
TARDIS.MetadataCustomVersions = {}

TARDIS.ExteriorsMetadata = {}
TARDIS.ExteriorsMetadataRaw = {}

TARDIS.IntCustomSettings = {}
TARDIS.IntUpdatesPerTemplate = {}


function TARDIS:PreMergeExteriorMetadata(ext_m)
    if ext_m and ext_m.Teleport then
        if ext_m.Teleport.DematSequence then
            ext_m.Teleport.DematSequenceSaved = table.Copy(ext_m.Teleport.DematSequence)
        end

        if ext_m.Teleport.MatSequence then
            ext_m.Teleport.MatSequenceSaved = table.Copy(ext_m.Teleport.MatSequence)
        end
    end
end

function TARDIS:PostMergeExteriorMetadata(ext_m)
    if ext_m and ext_m.Teleport then
        if ext_m.Teleport.DematSequenceSaved then
            ext_m.Teleport.DematSequence = ext_m.Teleport.DematSequenceSaved
            ext_m.Teleport.DematSequenceSaved = nil
        end

        if ext_m.Teleport.MatSequenceSaved then
            ext_m.Teleport.MatSequence = ext_m.Teleport.MatSequenceSaved
            ext_m.Teleport.MatSequenceSaved = nil
        end
    end
end

function TARDIS:MergeMetadata(base, t)
    local copy=table.Copy(base)
    self:PreMergeExteriorMetadata(t.Exterior)
    table.Merge(copy,t)
    self:PostMergeExteriorMetadata(copy.Exterior)
    return copy
end

function TARDIS:ClearMetadata(id)
    self.Metadata[id] = nil
    for k,v in pairs(self.MetadataRaw) do
        if v.Base == id then
            self:ClearMetadata(k)
        end
    end
end

function TARDIS:AddInterior(t)
    local id = t.ID

    self.MetadataRaw[id] = t

    self:ClearMetadata(id)

    -- setting up the stuff we need before spawning, e.g. in spawnmenu
    self:SetupVersions(id)
    self:AddSpawnmenuInterior(id)
    self:SetupTemplateUpdates(id)
    self:SetupCustomSettings(id)
end

function TARDIS:SetupMetadata(id)
    if self.Metadata[id] then return end
    local t = self.MetadataRaw[id]
    if not t then return end

    local base = t.Base

    if base == true then
        self.Metadata[id] = t
        return
    end

    self:SetupMetadata(base)

    local m_base = self.Metadata[base]
    if not m_base then return end

    self.Metadata[id] = self:MergeMetadata(m_base, t)
    self.Metadata[id].Versions = nil -- we don't want those mixing up anywhere
end

function TARDIS:CreateInteriorMetadata(id, ent)
    if id == nil then
        local cv_id = GetConVar("tardis2_selected_interior"):GetString()
        if cv_id ~= "" then
            id = cv_id
        end
    end

    self:SetupMetadata(id)

    if self.Metadata[id] == nil then
        return self:CreateInteriorMetadata("default", ent)
    end

    local metadata = TARDIS:CopyTable(self.Metadata[id])

    metadata = TARDIS:MergeTemplates(metadata, ent)

    metadata.Interior.TextureSets = TARDIS:GetMergedTextureSets(metadata.Interior.TextureSets)
    metadata.Exterior.TextureSets = TARDIS:GetMergedTextureSets(metadata.Exterior.TextureSets)

    return metadata
end

function TARDIS:GetInteriors()
    return self.MetadataRaw
end

function TARDIS:GetInterior(id)
    return self.Metadata[id] or self.MetadataRaw[id]
end

TARDIS:LoadFolder("interiors/modules")
TARDIS:LoadFolder("interiors", nil, true)
TARDIS:LoadFolder("interiors/versions", nil, true)
