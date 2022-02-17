function ENT:ApplyTextureSet(set_id)
    if not self.metadata or not self.metadata.Interior.TextureSets then return end

    local texture_set = self.metadata.Interior.TextureSets[set_id]
    if not texture_set then return end

    local prefix = texture_set.prefix or ""

    for i,v in ipairs(texture_set) do
        local ent = (v[1] == "self") and self or self:GetPart(v[1])

        if IsValid(ent) then
            if isnumber(v[2]) and v[3] ~= nil then
                ent:SetSubMaterial(v[2], prefix .. v[3])
            elseif isstring(v[2]) then
                ent:SetMaterial(prefix .. v[2])
            elseif isnumber(v[2]) then
                ent:SetSkin(v[2])
            else
                ErrorNoHaltWithStack("Wrong texture set parameter format: " .. v[2])
            end
        end
    end

end