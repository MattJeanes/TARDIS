-- April Fools

if SERVER then
    ENT:AddHook("PreDematStart", "april_fools", function(self, ignore_health)
        if not TARDIS:IsAprilFools() then
            return
        end
        if not IsValid(self.interior) then
            return
        end

        constraint.Weld(self, self.interior, 0, 0, 0, false, false)
    end)

    ENT:AddHook("DematStart", "april_fools", function(self)
        if (not TARDIS:IsAprilFools()) then
            return
        end

        for ply, v in pairs(self.occupants) do
            if v and IsValid(ply) and not ply.tardis_aprilfools then
                ply.tardis_aprilfools = true
                ply:ChatPrint("April fools! :) (tardis2_aprilfools_2023 0 in console to disable)")
            end
        end
    end)

    ENT:AddHook("StopDemat", "april_fools", function(self, ignore_health)
        if not TARDIS:IsAprilFools() then
            return
        end
        self:Remove()
    end)
else
    ENT:AddHook("PreDematStart", "april_fools", function(self, ignore_health)
        if not TARDIS:IsAprilFools() then
            return
        end
        if not IsValid(self.interior) then
            return
        end

        for k, v in pairs(self.interior:GetParts()) do
            if IsValid(v) then
                v.RenderGroup = RENDERGROUP_BOTH
            end
        end
    end)
end

ENT:AddHook("Think","teleport",function(self,delta)
    if not TARDIS:IsAprilFools() then return end
    if IsValid(self.interior) then
        local alpha = self:GetData("alpha",255)
        for k,v in pairs(self.interior:GetParts()) do
            if IsValid(v) then
                v:SetColor(Color(255,255,255,alpha))
            end
        end
    end
end)
