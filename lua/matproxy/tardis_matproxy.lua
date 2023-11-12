matproxy.Add({
    name = "TARDIS_State",

    init = function(self, mat, values)
        self.Texture = values.resulttexturevar
        self.FrameNo = values.resultframevar

        self.Textures = table.Copy(values.textures)
        self.FrameRates = table.Copy(values.framerates)

        self.AnimateTextures = {}
        self.FrameDurations = {}
        self.FrameNumbers = {}

        for k,v in pairs(self.Textures) do
            local animate = (self.FrameRates[k] and self.FrameRates[k] > 0)
            self.AnimateTextures[k] = animate
            if animate then
                self.FrameDurations[k] = 1.0 / self.FrameRates[k]
            end
        end

        self.next_frame_update = RealTime()
        self.last_frame_update = RealTime()
        self.current_frame = 0
    end,

    bind = function(self, mat, ent)
        if not IsValid(ent) or not ent.TardisPart then return end
        local ext = ent.exterior
        if not IsValid(ext) then return end

        local function get_base_mat_name()
            if not ext:GetPower() then
                return "off"
            elseif ext:GetData("failing-demat") then
                return "demat_fail"
            elseif ext:GetData("failing-mat") then
                return "mat_fail"
            elseif ext:GetData("demat-interrupted") then
                return "interrupt"
            elseif ext:GetHandbrake() then
                return "handbrake"
            elseif ext:GetData("demat_animation") then
                return "demat"
            elseif ext:GetData("mat_animation") then
                return "mat"
            elseif ext:IsTravelling() then
                return "travel"
            end

            return "idle"
        end

        local m = get_base_mat_name()

        if ext:GetWarning() then
            m = m .. "_warning"
        end

        if not self.Textures or not self.Textures[m] then return end

        if mat:GetTexture(self.Texture):GetName() ~= self.Textures[m] then
            mat:SetTexture(self.Texture, self.Textures[m])
        end

        if self.AnimateTextures[m] then
            local num_frames = mat:GetTexture(self.Texture):GetNumAnimationFrames()
            local time = RealTime()

            if time > self.next_frame_update then
                local time_past = time - self.last_frame_update
                local frames_past = math.floor(time_past / self.FrameDurations[m])

                self.current_frame = (self.current_frame + frames_past) % num_frames

                self.last_frame_update = time
                self.next_frame_update = time + self.FrameDurations[m]
            end
        else
            self.current_frame = 0
        end

        mat:SetInt(self.FrameNo, self.current_frame)
    end
})

local function matproxy_tardis_power_init(self, mat, values)
    self.ResultTo = values.resultvar
    self.on_var = values.onvar
    self.off_var = values.offvar
end

local function matproxy_tardis_power_bind(self, mat, ent)
    if not IsValid(ent) or not IsValid(ent.exterior) or not ent.TardisPart then return end

    local var = ent.exterior:GetPower() and self.on_var or self.off_var
    if not var then return end

    mat:SetVector(self.ResultTo, mat:GetVector(var))
end

matproxy.Add({
    name = "TARDIS_Power",
    init = matproxy_tardis_power_init,
    bind = matproxy_tardis_power_bind,
})

matproxy.Add({
    name = "TARDIS_Power2",
    init = matproxy_tardis_power_init,
    bind = matproxy_tardis_power_bind,
})

matproxy.Add({
    name = "TARDIS_Power3",
    init = matproxy_tardis_power_init,
    bind = matproxy_tardis_power_bind,
})


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
