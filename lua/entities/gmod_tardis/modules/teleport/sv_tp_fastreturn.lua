-- Fast return

function ENT:FastReturn(callback)
    local retpos, retang = self:GetData("fastreturn-pos"), self:GetData("fastreturn-ang")

    if not retpos then
        if callback then callback(false) end
        return
    end

    if self:GetData("vortex") and not self:GetData("fastreturn") then
        self:SetDestination(retpos, retang)
        self:Mat(callback)
        return
    end

    if self:CallHook("CanDemat", true) == false then
        if callback then callback(false) end
        return
    end

    self:SetData("demat-fast-prev", self:GetFastRemat());
    self:SetFastRemat(true)
    self:SetData("fastreturn",true)
    self:CallHook("FastReturnTriggered")
    self:AutoDemat(retpos, retang, callback)
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

ENT:AddHook("CanChangeDestination", "fastreturn", function(self, pos, ang)
    if not self:GetData("fastreturn") then return end

    if self:GetData("teleport") or self:GetData("vortex") then
        return false
    end
end)
