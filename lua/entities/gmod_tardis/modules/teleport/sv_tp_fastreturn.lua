function ENT:FastReturn(callback)
    if self:CallHook("CanDemat") ~= false and self:GetData("fastreturn-pos") then
        self:SetData("demat-fast-prev", self:GetData("demat-fast", false));
        self:SetFastRemat(true)
        self:SetData("fastreturn",true)
        self:CallHook("FastReturnTriggered")
        self:Demat(self:GetData("fastreturn-pos"),self:GetData("fastreturn-ang"))
        if callback then callback(true) end
    else
        if callback then callback(false) end
    end
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

