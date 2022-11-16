-- Lights

CreateConVar("tardis2_debug_lamps", 0, {FCVAR_ARCHIVE}, "TARDIS - enable debugging interior lamps")

if SERVER then
    util.AddNetworkString("TARDIS-DebugLampsToggled")

    -- It was required to manually code networking for this convar
    -- AddChangeCallback doesn't callback client convars with FCVAR_REPLICATED
    -- Details: https://github.com/Facepunch/garrysmod-issues/issues/3740

    cvars.AddChangeCallback("tardis2_debug_lamps", function()
        TARDIS.debug_lamps_enabled = GetConVar("tardis2_debug_lamps"):GetBool()
        net.Start("TARDIS-DebugLampsToggled")
            net.WriteBool(TARDIS.debug_lamps_enabled)
        net.Broadcast()
    end)
else
    net.Receive("TARDIS-DebugLampsToggled", function()
        TARDIS.debug_lamps_enabled = net.ReadBool()
    end)
end

TARDIS.debug_lamps_enabled = GetConVar("tardis2_debug_lamps"):GetBool()

if CLIENT then

    function ENT:DrawLight(id,light)
        if self:CallHook("ShouldDrawLight",id,light)==false then return end
        local dlight = DynamicLight(id, true)
        if ( dlight ) then
            local size=1024
            local c=light.color
            local warnc = light.warncolor or c
            local warning = self.exterior:GetData("health-warning", false)
            dlight.Pos = self:LocalToWorld(light.pos)
            dlight.r = warning and warnc.r or c.r
            dlight.g = warning and warnc.g or c.g
            dlight.b = warning and warnc.b or c.b
            dlight.Brightness = light.brightness
            dlight.Decay = size * 5
            dlight.Size = size
            dlight.DieTime = CurTime() + 1
        end
    end

    ENT:AddHook("Think", "lights", function(self)
        if TARDIS:GetSetting("lightoverride-enabled") then return end
        local light=self.metadata.Interior.Light
        local lights=self.metadata.Interior.Lights
        local index=self:EntIndex()
        if light then
            self:DrawLight(index,light)
        end
        if lights then
            local i=0
            for _,light in pairs(lights) do
                i=i+1
                self:DrawLight((index*1000)+i,light)
            end
        end
    end)

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

    function ENT:CreateProjectedLights()
        if TARDIS.debug_lamps_enabled then return end

        local lamps = self.metadata.Interior.Lamps
        if not lamps then return end

        self.projected_lights = {}

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
                self.projected_lights[k] = pl
            end
        end
    end

    function ENT:UpdateProjectedLights()
        if not TARDIS:GetSetting("projlights-enabled") then return end
        if not self.projected_lights then return end

        self.projected_lights_need_updating = true

        self:Timer("projlights_update_stop", 1, function()
            self.projected_lights_need_updating = false
        end)
    end

    function ENT:RemoveProjectedLights()
        if not self.projected_lights then return end

        for k,v in pairs(self.projected_lights) do
            if IsValid(v) then
                v:Remove()
            end
        end

        self.projected_lights = nil
    end

    ENT:AddHook("Initialize", "projected_lights", function(self)
        self:CreateProjectedLights()
    end)

    ENT:AddHook("PostInitialize", "projected_lights", function(self)
        self:UpdateProjectedLights()
    end)

    ENT:AddHook("ToggleDoor", "projected_lights", function(self)
        self:UpdateProjectedLights()
    end)

    ENT:AddHook("PlayerEnter", "projected_lights", function(self)
        self:UpdateProjectedLights()
    end)

    ENT:AddHook("Think", "projected_lights_updates", function(self)
        if not self.projected_lights_need_updating then return end

        if not TARDIS:GetSetting("projlights-enabled") then return end
        if not self.projected_lights then return end

        for k,v in pairs(self.projected_lights) do
            if IsValid(v) then
                v:Update()
            end
        end
    end)

    ENT:AddHook("OnRemove", "projected_lights", function(self)
        self:RemoveProjectedLights()
    end)

    ENT:AddHook("SettingChanged", "projected_lights", function(self, id, val)
        if id ~= "projlights-enabled" then return end

        if val and not self.projected_lights then
            self:CreateProjectedLights()
        elseif not val and self.projected_lights then
            self:RemoveProjectedLights()
        end
    end)

    ENT:AddHook("PowerToggled", "lamps", function(self, on)
        if not self.projected_lights then return end

        local lamps = self.metadata.Interior.Lamps

        for k,v in pairs(lamps) do
            if not v.nopower and self.projected_lights[k] then
                self.projected_lights[k]:SetBrightness(on and v.brightness or 0)
                self.projected_lights[k]:Update()
            end
        end
    end)


else -- SERVER
    ENT:AddHook("Initialize", "lamps", function(self)
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

    ENT:AddHook("OnRemove", "lamps", function(self)
        if not self.debug_lamps then return end
        for k,v in pairs(self.debug_lamps) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end)

    ENT:AddHook("PowerToggled", "lamps", function(self, on)
        if not self.debug_lamps then return end

        for k,v in pairs(self.debug_lamps) do
            if IsValid(v) and v.lamp_data.nopower ~= true then
                v:SetOn(on)
            end
        end
    end)

end
