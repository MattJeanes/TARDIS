-- Door

ENT:AddHook("PostInitialize","intdoor_behaviour",function(self)
    local intdoor_part = self:GetPart("intdoor")
    if not IsValid(intdoor_part) then return end

    local ply = self:GetCreator()
    local setting = TARDIS:GetSetting("intdoor_behaviour", ply)
    self:SetData("intdoor_behaviour", setting, true)
end)

function ENT:DoorOpen(...)
    return self.exterior:DoorOpen(...)
end