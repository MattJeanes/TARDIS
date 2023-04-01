-- April Fools

if SERVER then
    ENT:AddHook("PreTeleportPositionChange", "april_fools", function(self)
        if not TARDIS:IsAprilFools() then return end

        for ply, v in pairs(self.occupants) do
            if v and IsValid(ply) and not ply.tardis_aprilfools then
                ply.tardis_aprilfools = true
                ply:ChatPrint("April fools! :) (tardis2_aprilfools_2023 0 in console to disable)")
            end
        end

        self:Remove()
        return false
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
        self.interior.tips = {}
    end)
end

ENT:AddHook("Think", "april_fools", function(self,delta)
    if not TARDIS:IsAprilFools() then return end
    if IsValid(self.interior) then
        local alpha = self:GetData("alpha",255)
        self.interior:SetColor(ColorAlpha(self.interior:GetColor(),alpha))
        local parts = self.interior:GetParts()
        if not parts then return end
        for k,v in pairs(parts) do
            if IsValid(v) then
                v:SetColor(ColorAlpha(v:GetColor(),alpha))
            end
        end
    end
end)
