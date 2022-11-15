-- Lights

CreateConVar("tardis2_debug_lamps", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - enable debugging interior lamps")
cvars.AddChangeCallback("tardis2_debug_lamps", function()
    TARDIS.debug_lamps = GetConVar("tardis2_debug_lamps"):GetBool()
end)

TARDIS.debug_lamps = GetConVar("tardis2_debug_chat"):GetBool()

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

else -- SERVER
    
    if SERVER then
        ENT:AddHook("Initialize", "lamps", function(self)
            local lamps = self.metadata.Interior.Lamps
            if not lamps then return end

            self.lamps = {}

            for k,v in pairs(lamps) do
                if v then
                    local lamp = MakeLamp(nil, --self:GetCreator(),
                        v.color.r, v.color.g, v.color.b, KEY_NONE, true,
                        v.texture or "effects/flashlight/soft",
                        "models/maxofs2d/lamp_projector.mdl",
                        v.fov or 90, v.distance or 1024, v.brightness or 3.0, true,
                        {
                            Pos = self:LocalToWorld(v.pos or Vector(0,0,0)),
                            Angle = v.ang or Angle(0,0,0),
                        })

                    lamp:SetUnFreezable(false)
                    lamp:GetPhysicsObject():EnableGravity(false)
                    lamp:GetPhysicsObject():EnableMotion(false)

                    if TARDIS.debug_lamps then
                        lamp:SetUseType(SIMPLE_USE)
                        lamp.Use = function(ply)
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
                    else
                        lamp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                        lamp:SetRenderMode(RENDERMODE_TRANSALPHA)
                        lamp:SetColor(Color(v.color.r, v.color.g, v.color.b,0))
                    end

                    lamp.lamp_data = v

                    table.insert(self.lamps, lamp)
                end
            end
        end)
    end

    ENT:AddHook("OnRemove", "lamps", function(self)
        if not self.lamps then return end
        for k,v in pairs(self.lamps) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end)

    ENT:AddHook("PowerToggled", "lamps", function(self, on)
        if not self.lamps then return end
        for k,v in pairs(self.lamps) do
            if IsValid(v) and v.lamp_data.nopower ~= true then
                v:SetOn(on)
            end
        end
    end)

end