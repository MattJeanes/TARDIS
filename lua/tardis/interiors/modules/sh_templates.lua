function TARDIS:AddInteriorPartsOffset(template, offset)
    local moved = table.Copy(template)

    if istable(moved.Interior.Parts) then
        for k,v in pairs(moved.Interior.Parts) do
            if v and istable(v) then
                local new_pos = Vector(0,0,0)
                if v.pos then new_pos:Add(v.pos) end
                new_pos:Add(offset)
                v.pos = new_pos
            end
        end
    end

    if istable(moved.Interior.PartTips) then
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

    if istable(moved.Interior.CustomTips) then
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

function TARDIS:AddInteriorPartsRotation(template, rotate_ang)
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


function TARDIS:SetupTemplateUpdates(id)
    local t = self.MetadataRaw[id]
    if not t.Templates then return end

    for template_id, template in pairs(t.Templates) do
        if template then
            self.IntUpdatesPerTemplate[template_id] = self.IntUpdatesPerTemplate[template_id] or {}
            self.IntUpdatesPerTemplate[template_id][id] = true
        end
    end
end

function TARDIS:MergeTemplates(metadata, ent)
    if not metadata.Templates then
        return metadata
    end

    local id = metadata.ID

    for template_id, template in pairs(metadata.Templates) do

        if template and template.realID then
            template_id = template.realID
        end

        local template_metadata = self.MetadataTemplates[template_id]

        if template and template_metadata
            and (not template.condition or (ent and template.condition and template.condition(id, ent:GetCreator(), ent) ))
        then
            if template.parts_rotation then
                template_metadata = self:AddInteriorPartsRotation(template_metadata, template.parts_rotation)
            end
            if template.parts_offset then
                template_metadata = self:AddInteriorPartsOffset(template_metadata, template.parts_offset)
            end

            if template.override then
                metadata = TARDIS:MergeMetadata(metadata, template_metadata)
            else
                metadata = TARDIS:MergeMetadata(template_metadata, metadata)
            end

        elseif not template_metadata then

            local can_print = CLIENT and LocalPlayer() and LocalPlayer().ChatPrint

            if not template or not template.ignore_missing then
                local err_notification = "[TARDIS] "..TARDIS:GetPhrase("Templates.MissingTemplate", template_id, id)
                if can_print then
                    LocalPlayer():ChatPrint(err_notification)
                else
                    ErrorNoHalt("\n" .. err_notification)
                end
            end
            if template and template.fail_msg then
                if can_print then
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

    return metadata
end

function TARDIS:AddInteriorTemplate(id, template)
    if not id or not template then return end

    local int_updates = self.IntUpdatesPerTemplate[id]
    if int_updates then
        for i,int_id in ipairs(int_updates) do
            if template.CustomSettings then
                self:SetupCustomSettings(int_id)
            end
        end
    end

    self.MetadataTemplates[id] = template
end

-- Texture set support of inherited params

function TARDIS:GetMergedTextureSets(texture_sets_table)
    if not texture_sets_table then
        return texture_sets_table
    end

    local texture_sets_merged = {}

    local function merge_texture_set(id)
        local ts = texture_sets_table[id]

        if not ts.base then
            texture_sets_merged[id] = ts
            return
        end

        if not texture_sets_merged[ts.base] then
            merge_texture_set(ts.base)
        end

        local base_merged = texture_sets_merged[ts.base] or {}
        local merged = TARDIS:MergeMetadata(base_merged, ts)
        texture_sets_merged[id] = merged
    end

    for ts_id, ts in pairs(texture_sets_table) do
        merge_texture_set(ts_id)
    end

    return texture_sets_merged
end

TARDIS:LoadFolder("interiors/templates", nil, true)