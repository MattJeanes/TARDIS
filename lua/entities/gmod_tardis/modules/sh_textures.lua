function ENT:ApplyTextureSet(set_id)
    if not self:GetExtMetadata() or not self:GetExtMetadata().TextureSets then return end

    local texture_set = self:GetExtMetadata().TextureSets[set_id]
    if not texture_set then return end

    local prefix = texture_set.prefix or ""

    for i,v in ipairs(texture_set) do
        self:ChangeTexture(v[1], v[2], v[3], prefix)
    end

end

--[[
    Usage examples:
        self:ChangeTexture(id, <submaterial_no>, <material>)
        self:ChangeTexture(id, <material>)
        self:ChangeTexture(id, <skin_no>)
]]
function ENT:ChangeTexture(part_id, a, b, prefix)
    local ent = (part_id == "self") and self or self:GetPart(part_id)
    if not IsValid(ent) then return end

    if not prefix then prefix = "" end

    if isnumber(a) and b ~= nil then
        ent:SetSubMaterial(a, prefix .. b)
    elseif isstring(a) then
        ent:SetMaterial(prefix .. a)
    elseif isnumber(a) then
        ent:SetSkin(a)
    else
        ErrorNoHaltWithStack("Wrong texture parameter format: " .. a)
    end
end