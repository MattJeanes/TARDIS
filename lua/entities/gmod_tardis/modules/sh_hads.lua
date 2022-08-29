-- Hostile Action Displacement System

if SERVER then
    function ENT:SetHADS(on)
        return self:SetData("hads",on,true)
    end

    function ENT:ToggleHADS()
        local on = not self:GetData("hads",false)
        return self:SetHADS(on)
    end

    function ENT:TriggerHADS()
        if self:CallHook("CanTriggerHads") == false then 
            return false 
        end
        if (self:GetData("hads",false) == true
            and self:GetData("hads-triggered",false)==false)  
            and (not self:GetData("teleport",false)) 
        then
            if self:GetData("doorstatereal") then
                self:ToggleDoor()
            end
            if self:GetData("handbrake") then
                self:ToggleHandbrake()
            end
            if self:CallHook("CanDemat", true) == false then
                if not self:GetData("hads-failed-time") or CurTime() > self:GetData("hads-failed-time") + 10 then
                    self:SetData("hads-failed-time", CurTime())
                    TARDIS:ErrorMessage(self:GetCreator(), "HADS.DematError")
                    TARDIS:ErrorMessage(self:GetCreator(), "HADS.UnderAttack")
                end
                return false
            end
            TARDIS:Message(self:GetCreator(), "HADS.Triggered")
            TARDIS:Message(self:GetCreator(), "HADS.UnderAttack")
            self:SetData("hads-triggered", true)
            self:SetFastRemat(false)
            self:SetRandomDestination(true) 
            self:AutoDemat()
            self:CallHook("HADSTrigger")
            self:SetData("hads-need-remat", true, true)
            self:Timer("HadsRematTime", math.random(10,25), function()
                if self:GetData("hads-need-remat", false) then 
                    self:Mat(function(result)
                        if result then
                            TARDIS:Message(self:GetCreator(), "HADS.Mat")
                        end
                    end)
                end
            end)
            return true
        end
    end 

    ENT:AddHook("MatStart", "hads-cancel-remat", function(self)
        self:SetData("hads-need-remat", nil, true)
    end)

    ENT:AddHook("OnTakeDamage", "hads", function(self)
        self:TriggerHADS()  
    end)

    hook.Add("OnPhysgunPickup", "tardis-hads", function(ply,ent)
        if ent:GetClass()=="gmod_tardis" and ent:TriggerHADS() then
            ent:ForcePlayerDrop()                                                      
        end
    end)

    ENT:AddHook("StopDemat","hads",function(self)
        if self:GetData("hads-triggered",false) then
            self:SetData("hads-triggered",false,true)
        end
    end)

    ENT:AddHook("HandleE2", "hads", function(self,name,e2)
        if name == "GetHADS" then
            return self:GetData("hads",false) and 1 or 0
        elseif name == "HADS" and TARDIS:CheckPP(e2.player, self) then
            return self:ToggleHADS()
        end
    end)
end