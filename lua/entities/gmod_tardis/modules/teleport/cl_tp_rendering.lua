-- Draw and render teleport-related functions

ENT:AddHook("ShouldAllowThickPortal", "teleport", function(self, portal)
    if self.interior and portal==self.interior.portals.exterior then
        if self:GetData("teleport-trace") then
            return false
        end
    end
end)

hook.Add("PostDrawTranslucentRenderables", "tardis-trace", function()
    local ext=TARDIS:GetExteriorEnt()
    if not IsValid(ext) then return end

    local tp_trace = ext:GetData("teleport-trace")
    local dst_trace = ext:GetData("destination-trace") and LocalPlayer():GetTardisData("destination")

    if not tp_trace and not dst_trace then return end

    local pos, ang
    if tp_trace then
        pos,ang=ext:GetThirdPersonTrace(LocalPlayer(),LocalPlayer():EyeAngles())
    else
        pos,ang=ext:GetDestinationPropTrace(LocalPlayer(),LocalPlayer():EyeAngles())
    end

    local fw=ang:Forward()
    local bk=fw*-1
    local ri=ang:Right()
    local le=ri*-1

    local size=10
    local col=Color(255,0,0)
    render.DrawLine(pos,pos+(fw*size),col)
    render.DrawLine(pos,pos+(bk*size),col)
    render.DrawLine(pos,pos+(ri*size),col)
    render.DrawLine(pos,pos+(le*size),col)
end)
