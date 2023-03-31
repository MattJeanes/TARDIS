-- Teleport hooks

if SERVER then

    ENT:AddHook("CanToggleDoor","teleport",function(self,state)
        if self:GetData("teleport") then
            return false
        end
    end)

    ENT:AddHook("ShouldThinkFast","teleport",function(self)
        if self:GetData("teleport") then
            return true
        end
    end)

    ENT:AddHook("CanPlayerEnter","teleport",function(self)
        if self:GetData("teleport") or self:GetData("vortex") then
            return false, true
        end
    end)

    ENT:AddHook("CanPlayerEnterDoor","teleport",function(self)
        if (self:GetData("teleport") or self:GetData("vortex")) then
            return false
        end
    end)

    ENT:AddHook("CanPlayerExit","teleport",function(self)
        if self:GetData("teleport") or self:GetData("vortex") then
            return false
        end
    end)

    ENT:AddHook("ShouldTurnOnRotorwash", "teleport", function(self)
        if self:GetData("teleport") then
            return true
        end
    end)

    ENT:AddHook("ShouldExteriorDoorCollide", "teleport", function(self,open)
        if self:GetData("teleport") or self:GetData("vortex") then
            return false
        end
    end)

    ENT:AddHook("CanRepair", "teleport", function(self, ignore_health)
        if self:GetData("teleport") or self:GetData("vortex") then
            return false
        end
    end)

    ENT:AddHook("PreDematStart", "april_fools", function(self, ignore_health)
        if not TARDIS:IsAprilFools() then return end
        if not IsValid(self.interior) then return end

        constraint.Weld(self, self.interior, 0, 0, 0, false, false)
    end)

    ENT:AddHook("DematStart", "april_fools", function(self)
        if (not TARDIS:IsAprilFools()) then return end

        for ply,v in pairs(self.occupants) do
            if v and IsValid(ply) and not ply.tardis_aprilfools then
                ply.tardis_aprilfools = true
                ply:ChatPrint("April fools! :) (tardis2_aprilfools_2023 0 in console to disable)")
            end
        end
    end)

    ENT:AddHook("StopDemat", "april_fools", function(self, ignore_health)
        if not TARDIS:IsAprilFools() then return end
        self:Remove()
    end)
else
    ENT:AddHook("PreDematStart", "april_fools", function(self, ignore_health)
        if not TARDIS:IsAprilFools() then return end
        if not IsValid(self.interior) then return end

        for k,v in pairs(self.interior:GetParts()) do
            if IsValid(v) then
                v.RenderGroup = RENDERGROUP_BOTH
            end
        end
    end)

    ENT:AddHook("ShouldTurnOnLight","teleport",function(self)
        if self:GetData("teleport") then
            return true
        end
    end)

    ENT:AddHook("ShouldPulseLight","teleport",function(self)
        if self:GetData("teleport") then
            return true
        end
    end)

    ENT:AddHook("ShouldTurnOffFlightSound", "teleport", function(self)
        if self:GetData("teleport") or (self:GetData("vortex") and TARDIS:GetExteriorEnt() ~= self) then
            return true
        end
    end)

    ENT:AddHook("PilotChanged","teleport",function(self,old,new)
        if self:GetData("teleport-trace") then
            self:SetData("teleport-trace",false)
        end
    end)
end

