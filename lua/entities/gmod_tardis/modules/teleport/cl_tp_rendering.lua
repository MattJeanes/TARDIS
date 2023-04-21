-- Draw and render teleport-related functions

local function shouldapply(self,part)
    if
        (self:GetData("teleport") or self:GetData("teleport-trace")) 
        and not (self:GetData("vortexalpha",0)>0 and TARDIS:GetExteriorEnt()==self)
        and ((not part) or (part and (not part.CustomAlpha)))
    then
        return true
    end
end

local function dopredraw(self,part)
    if shouldapply(self,part) then
        render.SetBlend((self:GetData("teleport-trace") and 20 or self:GetData("alpha",255))/255)
    end
end

local function dodraw(self,part)
    if shouldapply(self,part) then
        render.SetBlend(1)
    end
end

ENT:AddHook("PreDraw","teleport",dopredraw)
ENT:AddHook("PreDrawPart","teleport",dopredraw)
ENT:AddHook("Draw","teleport",dodraw)
ENT:AddHook("PostDrawPart","teleport",dodraw)

ENT:AddHook("ShouldAllowThickPortal", "teleport", function(self, portal)
    if self.interior and portal==self.interior.portals.exterior then
        if self:GetData("teleport-trace") then
            return false
        end
    end
end)

hook.Add("PostDrawTranslucentRenderables", "tardis-trace", function()
    local ext=TARDIS:GetExteriorEnt()
    if IsValid(ext) and ext:GetData("teleport-trace") then
        local pos,ang=ext:GetThirdPersonTrace(LocalPlayer(),LocalPlayer():EyeAngles())
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
    end
end)