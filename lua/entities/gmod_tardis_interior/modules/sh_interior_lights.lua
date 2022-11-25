-- Lights

-- Convar

CreateConVar("tardis2_debug_lamps", 0, {FCVAR_ARCHIVE}, "TARDIS - enable debugging interior lamps")
TARDIS.debug_lamps_enabled = GetConVar("tardis2_debug_lamps"):GetBool()



-- Dynamic lights

if CLIENT then
    local function ParseLightTable(lt, interior, default_falloff)
        lt.falloff = lt.falloff or default_falloff
        -- default falloff values were taken from cl_render.lua::predraw_o

        if lt.warncolor then
            lt.warn_color = lt.warncolor
            lt.warncolor = nil
        end

        lt.warn_color = lt.warn_color or lt.color
        lt.warn_pos = lt.warn_pos or lt.pos
        lt.warn_brightness = lt.warn_brightness or lt.brightness
        lt.warn_falloff = lt.warn_falloff or lt.falloff

        if lt.nopower then
            lt.off_color = lt.off_color or lt.color
            lt.off_pos = lt.off_pos or lt.pos
            lt.off_brightness = lt.off_brightness or lt.brightness
            lt.off_falloff = lt.off_falloff or lt.falloff

            -- defaulting `off + warn` to `off` unless specified otherwise
            lt.off_warn_color = lt.off_warn_color or lt.off_color
            lt.off_warn_pos = lt.off_warn_pos or lt.off_pos
            lt.off_warn_brightness = lt.off_warn_brightness or lt.off_brightness
            lt.off_warn_falloff = lt.off_warn_falloff or lt.off_falloff
        end

        -- optimize calculations in `cl_render.lua::predraw_o`
        lt.color_vec = lt.color:ToVector() * lt.brightness
        lt.pos_global = interior:LocalToWorld(lt.pos)

        lt.warn_color_vec = lt.warn_color:ToVector() * lt.warn_brightness
        lt.warn_pos_global = interior:LocalToWorld(lt.warn_pos)

        if lt.nopower then
            lt.off_pos_global = interior:LocalToWorld(lt.off_pos)
            lt.off_color_vec = lt.off_color:ToVector() * lt.off_brightness

            lt.off_warn_pos_global = interior:LocalToWorld(lt.off_warn_pos)
            lt.off_warn_color_vec = lt.off_warn_color:ToVector() * lt.off_warn_brightness
        end

        if not lt.states then return end

        for k,v in lt.states do
            ParseLightTable(v, self)
        end
    end

    ENT:AddHook("Initialize", "lights", function(self)
        local light = self.metadata.Interior.Light
        local lights = self.metadata.Interior.Lights

        self.light_data = {
            main = table.Copy(light),
            extra = {},
        }
        ParseLightTable(self.light_data.main, self, 20)

        if not lights then return end
        for k,v in pairs(lights) do
            if v and istable(v) then
                self.light_data.extra[k] = table.Copy(v)
                ParseLightTable(self.light_data.extra[k], self, 10)
            end
        end
    end)

    function ENT:DrawLight(id,light)
        if self:CallHook("ShouldDrawLight",id,light)==false then return end

        local dlight = DynamicLight(id, true)
        if not dlight then return end

        local warning = self:GetData("health-warning", false)
        local power = self:GetPower()

        if not power and warning then
            dlight.Pos = light.off_warn_pos_global
            dlight.r = light.off_warn_color.r
            dlight.g = light.off_warn_color.g
            dlight.b = light.off_warn_color.b
            dlight.Brightness = light.off_warn_brightness
        elseif not power then
            dlight.Pos = light.off_pos_global
            dlight.r = light.off_color.r
            dlight.g = light.off_color.g
            dlight.b = light.off_color.b
            dlight.Brightness = light.off_brightness
        elseif warning then
            dlight.Pos = light.warn_pos_global
            dlight.r = light.warn_color.r
            dlight.g = light.warn_color.g
            dlight.b = light.warn_color.b
            dlight.Brightness = light.warn_brightness
        else -- power & no warning
            dlight.Pos = light.pos_global
            dlight.r = light.color.r
            dlight.g = light.color.g
            dlight.b = light.color.b
            dlight.Brightness = light.brightness
        end

        dlight.Decay = 5120
        dlight.Size = 1024
        dlight.DieTime = CurTime() + 1
    end

    ENT:AddHook("Think", "lights", function(self)
        if TARDIS:GetSetting("lightoverride-enabled") then return end
        local light = self.light_data.main
        local lights = self.light_data.extra
        local index=self:EntIndex()
        if light then
            self:DrawLight(index,light)
        end
        if lights and not TARDIS:GetSetting("extra-lights-disabled") then
            local i=0
            for _,light in pairs(lights) do
                i=i+1
                self:DrawLight((index*1000)+i,light)
            end
        end
    end)

    ENT:AddHook("ShouldDrawLight", "enabled_check", function(self,id,light)
        if light.enabled == false then return false end
        -- allow disabling lights with light states
    end)
end



-- Lamps (projected lights)

if CLIENT then

    function ENT:CreateLamps()
        if not TARDIS:GetSetting("lamps-enabled") then return end
        if TARDIS.debug_lamps_enabled then return end

        local lamps = self.metadata.Interior.Lamps
        if not lamps then return end

        self.lamps = {}

        for k,v in pairs(lamps) do
            if v then
                local pl = ProjectedTexture()

                pl:SetTexture(v.texture or "effects/flashlight/soft")
                pl:SetPos(self:LocalToWorld(v.pos or Vector(0,0,0)))
                pl:SetAngles(v.ang or Angle(0,0,0))
                pl:SetFOV(v.fov or 90)
                pl:SetColor(v.color or Color(255,255,255))
                pl:SetBrightness(v.brightness or 3.0)
                pl:SetFarZ(v.distance or 1024)
                pl:SetEnableShadows(v.shadows or false)

                pl:Update()
                self.lamps[k] = pl
            end
        end

        self:UpdateLamps()
    end

    function ENT:UpdateLamps()
        if not TARDIS:GetSetting("lamps-enabled") then return end
        if not self.lamps then return end

        self.lamps_need_updating = true

        self:Timer("lamps_update_stop", 1, function()
            self.lamps_need_updating = false
        end)
    end

    function ENT:RemoveLamps()
        if not self.lamps then return end

        for k,v in pairs(self.lamps) do
            if IsValid(v) then
                v:Remove()
            end
        end

        self.lamps = nil
    end

    ENT:AddHook("Initialize", "lamps", function(self)
        self:CreateLamps()
    end)

    ENT:AddHook("PostInitialize", "lamps", function(self)
        self:UpdateLamps()
    end)

    ENT:AddHook("ToggleDoor", "lamps", function(self)
        self:UpdateLamps()
    end)

    ENT:AddHook("PlayerEnter", "lamps", function(self)
        self:UpdateLamps()
    end)

    ENT:AddHook("Think", "lamps_updates", function(self)
        if not self.lamps_need_updating then return end

        if not TARDIS:GetSetting("lamps-enabled") then return end
        if not self.lamps then return end

        for k,v in pairs(self.lamps) do
            if IsValid(v) then
                v:Update()
            end
        end
    end)

    ENT:AddHook("OnRemove", "lamps", function(self)
        self:RemoveLamps()
    end)

    ENT:AddHook("SettingChanged", "lamps", function(self, id, val)
        if id ~= "lamps-enabled" then return end

        if val and self.lamps == nil then
            self:CreateLamps()
        elseif not val and self.lamps then
            self:RemoveLamps()
        end
    end)

    ENT:AddHook("PowerToggled", "lamps", function(self, on)
        if not self.lamps then return end
        if not TARDIS:GetSetting("lamps-enabled") then
            on = false
        end

        local lamps = self.metadata.Interior.Lamps

        for k,v in pairs(lamps) do
            if not v.nopower and self.lamps[k] then
                self.lamps[k]:SetBrightness(on and v.brightness or 0)
                self.lamps[k]:Update()
            end
        end
    end)
end



-- Light states

local function ChangeSingleLightState(light_table, state)
    local new_state = light_table.states && light_table.states[state]
    if not new_state then return end
    table.Merge(light_table, new_state)
end

function ENT:ApplyLightState(state)
    self:CallHook("LightStateChanged", state)

    if CLIENT then
        local ldata = self.light_data
        ChangeSingleLightState(ldata.main, state)

        for k,v in pairs(ldata.extra) do
            ChangeSingleLightState(v, state)
        end
    end
end



-- Debug Lamps (a way for developers to set up the projected lights)

if SERVER then

    util.AddNetworkString("TARDIS-DebugLampsToggled")
    cvars.AddChangeCallback("tardis2_debug_lamps", function()
        TARDIS.debug_lamps_enabled = GetConVar("tardis2_debug_lamps"):GetBool()
        net.Start("TARDIS-DebugLampsToggled")
            net.WriteBool(TARDIS.debug_lamps_enabled)
        net.Broadcast()
        -- It was required to manually code networking for this convar
        -- AddChangeCallback doesn't callback client convars with FCVAR_REPLICATED
        -- Details: https://github.com/Facepunch/garrysmod-issues/issues/3740
    end)

    ENT:AddHook("Initialize", "debug_lamps", function(self)
        if not TARDIS.debug_lamps_enabled then return end

        local lamps = self.metadata.Interior.Lamps
        if not lamps then return end

        self.debug_lamps = {}

        for k,v in pairs(lamps) do
            if v then
                local lamp = MakeLamp(nil, -- creator
                    v.color.r, v.color.g, v.color.b,
                    KEY_NONE, -- toggle key
                    true, -- toggle
                    v.texture or "effects/flashlight/soft", -- projected texture
                    "models/maxofs2d/lamp_projector.mdl", -- lamp model
                    v.fov or 90,
                    v.distance or 1024,
                    v.brightness or 3.0,
                    true, -- enabled
                    {
                        Pos = self:LocalToWorld(v.pos or Vector(0,0,0)),
                        Angle = v.ang or Angle(0,0,0),
                    }
                )

                lamp:SetUnFreezable(false)
                lamp:GetPhysicsObject():EnableGravity(false)
                lamp:GetPhysicsObject():EnableMotion(false)

                lamp:SetUseType(SIMPLE_USE)
                lamp.Use = function(lamp, ply)
                    local clr = lamp:GetColor()
                    local pos = self:WorldToLocal(lamp:GetPos())
                    local ang = lamp:GetAngles()

                    print("{\n\tcolor = Color(" .. clr.r .. ", " .. clr.g .. ", " .. clr.b .. "),")
                    print("\ttexture = \"" .. lamp:GetFlashlightTexture() .. "\",")
                    print("\tfov = " .. lamp:GetLightFOV() .. ",")
                    print("\tdistance = " .. lamp:GetDistance() .. ",")
                    print("\tbrightness = " .. lamp:GetBrightness() .. ",")
                    print("\tpos = Vector(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. "),")
                    print("\tang = Angle(" .. ang.x .. ", " .. ang.y .. ", " .. ang.z .. "),")
                    print("},")
                end
                lamp:SetCollisionGroup(COLLISION_GROUP_WORLD)

                lamp.lamp_data = v

                table.insert(self.debug_lamps, lamp)
            end
        end
    end)

    ENT:AddHook("OnRemove", "debug_lamps", function(self)
        if not self.debug_lamps then return end
        for k,v in pairs(self.debug_lamps) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end)

    ENT:AddHook("PowerToggled", "debug_lamps", function(self, on)
        if not self.debug_lamps then return end

        for k,v in pairs(self.debug_lamps) do
            if IsValid(v) and v.lamp_data.nopower ~= true then
                v:SetOn(on)
            end
        end
    end)
else
    net.Receive("TARDIS-DebugLampsToggled", function()
        TARDIS.debug_lamps_enabled = net.ReadBool()
    end)
end

-- Round things (light sprites for old default interior)
if CLIENT then
    function ENT:AddRoundThing(pos)
        self.roundthings[pos]=util.GetPixelVisibleHandle()
    end

    ENT:AddHook("Initialize", "lights-roundthings", function(self)
        if self.metadata.Interior.RoundThings then
            self.roundthingmat=Material("sprites/light_ignorez")
            self.roundthings={}
            for k,v in pairs(self.metadata.Interior.RoundThings) do
                self:AddRoundThing(v)
            end
        end
    end)

    local size=32
    ENT:AddHook("Draw", "lights-roundthings", function(self)
        if self.roundthings then
            if self:CallHook("ShouldDrawLight")==false then return end
            for k,v in pairs(self.roundthings) do
                local pos = self:LocalToWorld(k)
                local vis = util.PixelVisible(pos, 3, v)*255
                if vis > 0 then
                    render.SetMaterial(self.roundthingmat)
                    render.DrawSprite(pos, size, size, Color(255,153,0, vis))
                end
            end
        end
    end)
end
