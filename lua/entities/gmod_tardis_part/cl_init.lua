include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()

end

function ENT:IsInvisible()
    local p = self.parent
    if IsValid(p) and p.parts_visible and p.parts_visible[self.ID] == false then
        return true
    end
end