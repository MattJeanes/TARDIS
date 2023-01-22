function ENT:FastReturn(callback)
    if not self:GetData("fastreturn-pos") then callback(false) end
    if self:CallHook("CanDemat", true) == false then callback(false) end

    self:SetData("demat-fast-prev", self:GetData("demat-fast", false));
    self:SetFastRemat(true)
    self:SetData("fastreturn",true)
    self:CallHook("FastReturnTriggered")
    self:AutoDemat(self:GetData("fastreturn-pos"),self:GetData("fastreturn-ang"), callback)
end

ENT:AddHook("DematStart", "fastreturn", function(self)
    self:SetData("fastreturn-pos",self:GetPos())
    self:SetData("fastreturn-ang",self:GetAngles())
end)

ENT:AddHook("StopMat", "fastreturn", function(self)
    if self:GetData("fastreturn",false) then
        self:SetFastRemat(self:GetData("demat-fast-prev", false))
        self:SetData("fastreturn",false)
    end
end)

