local function AddInteriorPartsOffset(template, offset)
    local moved = table.Copy(template)

    if istable(rotated.Interior.Parts) then
        for k,v in pairs(moved.Interior.Parts) do
            if v and istable(v) then
                local new_pos = Vector(0,0,0)
                if v.pos then new_pos:Add(v.pos) end
                new_pos:Add(offset)
                v.pos = new_pos
            end
        end
    end

    if istable(rotated.Interior.PartTips) then
        for k,v in pairs(moved.Interior.PartTips) do
            if v and istable(v) then
                local new_pos = Vector(0,0,0)
                if v.pos then new_pos:Add(v.pos) end
                new_pos:Add(offset)
                v.pos = (new_pos == Vector(0,0,0)) and nil or new_pos
                -- sometimes tip.pos needs to be nil
            end
        end
    end

    if istable(rotated.Interior.CustomTips) then
        for k,v in pairs(moved.Interior.CustomTips) do
            if v and istable(v) then
                local new_pos = Vector(0,0,0)
                if v.pos then new_pos:Add(v.pos) end
                new_pos:Add(offset)
                v.pos = (new_pos == Vector(0,0,0)) and nil or new_pos
                -- sometimes tip.pos needs to be nil
            end
        end
    end

    return moved
end

local function AddInteriorPartsRotation(template, rotate_ang)
    local rotated = table.Copy(template)

    if istable(rotated.Interior.Parts) then
        for k,v in pairs(rotated.Interior.Parts) do
            if v and istable(v) then
                local new_ang = Angle(0,0,0)
                local new_pos = Vector(0,0,0)

                if v.ang then new_ang:Add(v.ang) end
                if v.pos then new_pos:Add(v.pos) end

                new_ang:Add(rotate_ang)
                new_pos:Rotate(rotate_ang)

                v.pos = new_pos
                v.ang = new_ang
            end
        end
    end

    if istable(rotated.Interior.PartTips) then
        for k,v in pairs(rotated.Interior.PartTips) do
            if v and istable(v) then
                local new_pos = Vector(0,0,0)
                if v.pos then new_pos:Add(v.pos) end
                new_pos:Rotate(rotate_ang)
                v.pos = (new_pos == Vector(0,0,0)) and nil or new_pos
                -- sometimes tip.pos needs to stay nil
            end
        end
    end

    if istable(rotated.Interior.CustomTips) then
        for k,v in pairs(rotated.Interior.CustomTips) do
            if v and istable(v) then
                local new_pos = Vector(0,0,0)
                if v.pos then new_pos:Add(v.pos) end
                new_pos:Rotate(rotate_ang)
                v.pos = (new_pos == Vector(0,0,0)) and nil or new_pos
                -- sometimes tip.pos needs to stay nil
            end
        end
    end

    return rotated
end


function TARDIS:MergeInteriorTemplates(cur_metadata, apply_conditions, ent)
    if not cur_metadata.Templates then
        return cur_metadata
    end

    local id = cur_metadata.ID
    local new_metadata = {}
    table.Merge(new_metadata, cur_metadata)
    -- we are not using table.Copy to avoid inheriting Vector and Angle objects

    for template_id, template in pairs(cur_metadata.Templates) do

        if template and template.realID then
            template_id = template.realID
        end

        local template_metadata = self.MetadataTemplates[template_id]

        if template and template_metadata
            and ((not apply_conditions and not template.condition)
                or (apply_conditions and template.condition and template.condition(id, ent:GetCreatorAdv(), ent)))
        then
            if template.parts_rotation then
                template_metadata = AddInteriorPartsRotation(template_metadata, template.parts_rotation)
            end
            if template.parts_offset then
                template_metadata = AddInteriorPartsOffset(template_metadata, template.parts_offset)
            end

            if template.override then
                new_metadata = TARDIS:MergeMetadata(new_metadata, template_metadata)
            else
                new_metadata = TARDIS:MergeMetadata(template_metadata, new_metadata)
            end

        elseif not template_metadata then
            if not template or not template.ignore_missing then
                local err_notification = "[TARDIS] Failed to find template " .. template_id .. " required for interior " .. id
                if CLIENT and LocalPlayer() and LocalPlayer().ChatPrint then
                    LocalPlayer():ChatPrint(err_notification)
                else
                    ErrorNoHalt("\n" .. err_notification)
                end
            end
            if template and template.fail_msg then
                if CLIENT and LocalPlayer() and LocalPlayer().ChatPrint then
                    LocalPlayer():ChatPrint(template.fail_msg)
                else
                    print("\n" .. template.fail_msg .. "\n")
                end
            end
            if template and template.fail then
                template.fail()
            end
        end
    end

    return new_metadata
end

function TARDIS:MergeTemplates()
    if not self.Metadata then return end

    for int_id, interior in pairs(self.Metadata) do
        self.Metadata[int_id] = TARDIS:MergeInteriorTemplates(self.Metadata[int_id], false)
    end
end

function TARDIS:AddInteriorTemplate(id, template)
    if not id or not template then return end

    if not template.NoFullReload and self.MetadataTemplates[id] ~= nil then
        TARDIS:FullReloadInteriors()
        return
    end

    template.NoFullReload = nil
    self.MetadataTemplates[id] = template
end

-- Texture set support of inherited params

function TARDIS:MergeIntTextureSets(int_id)
    local metadata = self.Metadata[int_id]
    if not metadata or not metadata.Interior.TextureSets then return end

    local TextureSetsMerged = {}

    local function merge_texture_set(id)
        local ts = metadata.Interior.TextureSets[id]

        if not ts.base then
            TextureSetsMerged[id] = ts
            return
        end

        if not TextureSetsMerged[ts.base] then
            merge_texture_set(ts.base)
        end

        local base_merged = TextureSetsMerged[ts.base] or {}
        local merged = TARDIS:MergeMetadata(base_merged, ts)
        TextureSetsMerged[id] = merged
    end

    for ts_id, ts in pairs(metadata.Interior.TextureSets) do
        merge_texture_set(ts_id)
    end

    self.Metadata[int_id].Interior.TextureSets = TextureSetsMerged
end

function TARDIS:MergeTextureSets()
    if not self.Metadata then return end

    for int_id, interior in pairs(self.Metadata) do
        TARDIS:MergeIntTextureSets(int_id)
    end
end