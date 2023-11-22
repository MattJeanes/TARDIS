-- Parts

ENT:AddHook("Initialize","parts",function(self)
    if SERVER then
        TARDIS:SetupParts(self)
    elseif self.partqueue then
        for k,v in pairs(self.partqueue) do
            TARDIS:SetupPart(k,v,self,self.interior,self)
        end
    end
end)

function ENT:GetPart(id)
    return self.parts and self.parts[id] or NULL
end

function ENT:GetParts()
    return self.parts
end

function ENT:SetPartVisible(id, visible)
    visible = visible or false

    if SERVER then
        self:SendMessage("part_visibility_change", {id, visible})
        return
    end

    self.parts_visible = self.parts_visible or {}
    self.parts_visible[id] = visible
end

if CLIENT then
    ENT:OnMessage("part_use", function(self,data,ply)
        local part = data[1]

        if IsValid(part) and part.Use then
            part:Use(unpack(data, 2))
        end
    end)

    ENT:OnMessage("part_visibility_change", function(self,data,ply)
        self:SetPartVisible(data[1], data[2])
    end)
end