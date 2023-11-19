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
