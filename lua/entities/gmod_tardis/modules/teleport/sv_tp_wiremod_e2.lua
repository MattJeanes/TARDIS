-- Wiremod-related teleport functions

ENT:AddWireInput("Demat", "Wiremod.Inputs.Demat")
ENT:AddWireInput("Mat", "Wiremod.Inputs.Mat")
ENT:AddWireInput("Pos", "Wiremod.Inputs.Pos", "VECTOR")
ENT:AddWireInput("Ang", "Wiremod.Inputs.Ang", "ANGLE")

ENT:AddHook("OnWireInput","teleport",function (self, name, value)
    if name == "Demat" and value >= 1 then
        self:Demat()
    elseif name == "Mat" and value >= 1 then
        self:Mat()
    elseif name == "Pos" then
        self:SetData("demat-pos",value,true)
    elseif name == "Ang" then
        self:SetData("demat-ang",value,true)
    end
end)

ENT:AddHook("HandleE2", "teleport_args", function(self, name, e2, pos, ang)
    if name == "Demat" and TARDIS:CheckPP(e2.player, self) then
        local success = self:CallHook("CanDemat")==false
        if not pos or not ang then
            self:Demat()
        else
            self:Demat(Vector(pos[1], pos[2], pos[3]), Angle(ang[1], ang[2], ang[3]))
        end
        return success and 0 or 1
    elseif name == "SetDestination" and TARDIS:CheckPP(e2.player, self) then
        local pos2 = Vector(pos[1], pos[2], pos[3])
        local ang2 = Angle(ang[1], ang[2], ang[3])
        return self:SetDestination(pos2,ang2) and 1 or 0
    end
end)

ENT:AddHook("HandleE2", "teleport_noargs", function(self, name, e2)
    if name == "Mat" and TARDIS:CheckPP(e2.player, self) then
        local success = (self:GetData("vortex",false) and self:CallHook("CanMat"))==false
        self:Mat()
        return success and 0 or 1
    elseif name == "Longflight" and TARDIS:CheckPP(e2.player, self) then
        return self:ToggleFastRemat() and 1 or 0
    elseif name == "FastReturn" and TARDIS:CheckPP(e2.player, self) then
        local success = self:CallHook("CanDemat")==false
        self:FastReturn()
        return success and 0 or 1
    elseif name == "FastDemat" and TARDIS:CheckPP(e2.player, self)then
        local success = self:CallHook("CanDemat")==false
        self:Demat()
        return success and 0 or 1
    end
end)

ENT:AddHook("HandleE2", "teleport_gets", function(self, name, e2)
    if name == "GetMoving" then
        return self:GetData("teleport",false) and 1 or 0
    elseif name == "GetInVortex" then
        return self:GetData("vortex",false) and 1 or 0
    elseif name == "GetLongflight" then
        return self:GetData("demat-fast",false) and 0 or 1
    elseif name == "LastAng" then
        return self:GetData("fastreturn-ang", {0,0,0})
    elseif name == "LastPos" then
        return self:GetData("fastreturn-pos", Vector(0,0,0))
    end
end)

