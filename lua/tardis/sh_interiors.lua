-- Interiors

CreateConVar("tardis2_selected_interior", "", {FCVAR_REPLICATED}, "TARDIS - selected interior to spawn when not using the spawnmenu")

TARDIS.Metadata = {}
TARDIS.MetadataRaw = {}
TARDIS.MetadataTemplates = {}
TARDIS.MetadataVersions = {}
TARDIS.MetadataCustomVersions = {}

TARDIS.IntCustomSettings = {}
TARDIS.IntUpdatesPerTemplate = {}


function TARDIS:PreMergeMetadata(t)
    if t.Exterior and t.Exterior.Teleport then
        if t.Exterior.Teleport.DematSequence then
            t.Exterior.Teleport.DematSequenceSaved = table.Copy(t.Exterior.Teleport.DematSequence)
        end

        if t.Exterior.Teleport.MatSequence then
            t.Exterior.Teleport.MatSequenceSaved = table.Copy(t.Exterior.Teleport.MatSequence)
        end
    end
end

function TARDIS:PostMergeMetadata(t)
    if t.Exterior and t.Exterior.Teleport then
        if t.Exterior.Teleport.DematSequenceSaved then
            t.Exterior.Teleport.DematSequence = t.Exterior.Teleport.DematSequenceSaved
            t.Exterior.Teleport.DematSequenceSaved = nil
        end

        if t.Exterior.Teleport.MatSequenceSaved then
            t.Exterior.Teleport.MatSequence = t.Exterior.Teleport.MatSequenceSaved
            t.Exterior.Teleport.MatSequenceSaved = nil
        end
    end
end

function TARDIS:MergeMetadata(base, t)
    local copy=table.Copy(base)
    self:PreMergeMetadata(t)
    table.Merge(copy,t)
    self:PostMergeMetadata(copy)
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
