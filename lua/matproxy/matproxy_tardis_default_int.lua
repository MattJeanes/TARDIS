matproxy.Add({
    name = "TARDIS_DefaultInt_EnvColor",

    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,

    bind = function(self, mat, ent)
        if not IsValid(ent) or not ent.TardisPart then return end

        local col = ent:GetData("default_int_env_color") or Color(0,200,255)
        col = Color(col.r, col.g, col.b):ToVector()

        if ent.exterior and not ent.exterior:GetPower() then
            col = col * 0.1
        end

        mat:SetVector( self.ResultTo, col);
    end
})

matproxy.Add({
    name = "TARDIS_DefaultInt_FloorLightsColor",

    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,

    bind = function(self, mat, ent)
        if not IsValid(ent) or not ent.TardisPart then return end

        local col = ent:GetData("default_int_floor_lights_color") or Color(230,230,210)

        col = Color(col.r, col.g, col.b):ToVector()

        mat:SetVector( self.ResultTo, col);
    end
})

matproxy.Add({
    name = "TARDIS_DefaultInt_RotorInColor",

    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,

    bind = function(self, mat, ent)
        if not IsValid(ent) or not ent.TardisPart then return end

        local col = ent:GetData("default_int_rotor_color") or Color(255,255,255)

        col = Color(col.r, col.g, col.b):ToVector()
        mat:SetVector( self.ResultTo, col);
    end
})

matproxy.Add({
    name = "TARDIS_DefaultInt_TelepathicsAddColor",

    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,

    bind = function(self, mat, ent)
        if not IsValid(ent) or not IsValid(ent.interior) or not ent.TardisPart then return end

        local time = ent.interior:GetData("default_telepathic_activation")
        local timediff = time and (RealTime() - time)

        if time == nil then
            time = LocalPlayer():GetTardisData("destination_last_exit")
            timediff = time and (CurTime() - time)
        end

        if time then
            timediff = math.Clamp(math.abs(timediff), 0, 1)
            mat:SetFloat(self.ResultTo, 0.7 * (1 - timediff))
            return
        end

        mat:SetFloat(self.ResultTo, 0)
    end
})


matproxy.Add({
    name = "TARDIS_DefaultInt_SonicCharger",
    init = function (self, mat, values)
        self.ResultTo = values.resultvar
        self.on_var = values.onvar
        self.off_var = values.offvar
    end,
    bind = function(self, mat, ent)
        if not IsValid(ent) or not IsValid(ent.exterior) or not ent.TardisPart then return end

        local var = ent:GetData("default_sonic_charger_active") and self.on_var or self.off_var
        if not var then return end

        mat:SetVector(self.ResultTo, mat:GetVector(var))
    end,
})

matproxy.Add({
    name = "TARDIS_DefaultInt_ThrottleLights",
    init = function (self, mat, values)
        self.ResultTo = values.resultvar
        self.on_var = values.onvar
        self.off_var = values.offvar

        self.ResultTo2 = values.resultvar2
        self.on_var2 = values.onvar2
        self.off_var2 = values.offvar2

        self.ResultTo3 = values.resultvar3
        self.on_var3 = values.onvar3
        self.off_var3 = values.offvar3
    end,
    bind = function(self, mat, ent)
        if not IsValid(ent) or not IsValid(ent.interior) or not ent.TardisPart or ent.ID ~= "default_throttle_lights" then
            mat:SetVector(self.ResultTo, mat:GetVector(self.on_var))
            mat:SetVector(self.ResultTo2, mat:GetVector(self.on_var2))
            mat:SetVector(self.ResultTo3, mat:GetVector(self.on_var3))
            return
        end

        local throttle = ent.interior:GetPart("default_throttle")
        if not IsValid(throttle) then return end

        local on = throttle:GetOn()
        local var = on and self.on_var or self.off_var
        local var2 = on and self.on_var2 or self.off_var2
        local var3 = on and self.on_var3 or self.off_var3
        if not var or not var2 or not var3 then return end

        mat:SetVector(self.ResultTo, mat:GetVector(var))
        mat:SetVector(self.ResultTo2, mat:GetVector(var2))
        mat:SetVector(self.ResultTo3, mat:GetVector(var3))
    end,
})

