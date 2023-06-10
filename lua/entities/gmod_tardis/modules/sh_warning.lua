if SERVER then
    ENT:AddHook("Initialize","warning-init", function(self)
        self:SetData("health-warning", false, true)
    end)

    function ENT:GetWarning()
        return self:GetData("health-warning", false)
    end

    function ENT:ToggleWarning()
        return self:SetWarning(not self:GetWarning())
    end

    function ENT:SetWarning(on)
        self:SetData("health-warning", on, true)
        self:CallCommonHook("HealthWarningToggled", on)
    end

    function ENT:UpdateWarning()
        if (self:CallCommonHook("ShouldWarningBeEnabled") == true) ~= self:GetWarning() then
            self:ToggleWarning()
        end
    end

    ENT:AddHook("HealthWarningToggled", "client", function(self, on)
        self:SendMessage("health_warning_toggled", {on})
    end)

    ENT:AddHook("Think", "health-warning", function(self)
        if self:CallHook("ShouldStartSmoke") and self:CallHook("ShouldStopSmoke")~=true then
            if self.smoke then return end
            self:StartSmoke()
        else
            self:StopSmoke()
        end
    end)

    ENT:AddHook("Think", "RemoveSmoke", function(self)
        local smokedelay = self:GetData("smoke-killdelay")
        if smokedelay ~= nil and CurTime() >= smokedelay then
            if IsValid(self.smoke) then
                self.smoke:Remove()
                self.smoke = nil
                self:SetData("smoke-killdelay",nil)
            end
        end
    end)

    ENT:AddHook("ShouldStartSmoke", "health-warning", function(self)
        if self:GetData("health-warning",false) then
            return true
        end
    end)

    function ENT:StartSmoke()
        local smoke = ents.Create("env_smokestack")
        smoke:SetPos(self:LocalToWorld(Vector(0,0,80)))
        smoke:SetAngles(self:GetAngles()+Angle(-90,0,0))
        smoke:SetKeyValue("InitialState", "1")
        smoke:SetKeyValue("WindAngle", "0 0 0")
        smoke:SetKeyValue("WindSpeed", "0")
        smoke:SetKeyValue("rendercolor", "50 50 50")
        smoke:SetKeyValue("renderamt", "170")
        smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
        smoke:SetKeyValue("BaseSpread", "5")
        smoke:SetKeyValue("SpreadSpeed", "10")
        smoke:SetKeyValue("Speed", "50")
        smoke:SetKeyValue("StartSize", "30")
        smoke:SetKeyValue("EndSize", "70")
        smoke:SetKeyValue("roll", "20")
        smoke:SetKeyValue("Rate", "10")
        smoke:SetKeyValue("JetLength", "100")
        smoke:SetKeyValue("twist", "5")
        smoke:Spawn()
        smoke:SetParent(self)
        smoke:Activate()
        self.smoke=smoke
    end

    function ENT:StopSmoke()
        if self.smoke and IsValid(self.smoke) and self:GetData("smoke-killdelay")==nil then
            self.smoke:Fire("TurnOff")
            local jetlength = self.smoke:GetInternalVariable("JetLength")
            local speed = self.smoke:GetInternalVariable("Speed")
            self:SetData("smoke-killdelay",CurTime()+(speed/jetlength)*5)
        end
    end

else

    ENT:OnMessage("health_warning_toggled", function(self, data, ply)
        self:CallCommonHook("HealthWarningToggled", data[1])
    end)

end
