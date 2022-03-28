-- Lights

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
        ENT:AddHook("Initialize", "lights-projected", function(self)
            --[[local pl = ProjectedTexture()
            pl:SetTexture(self.metadata.Exterior.ProjectedLight.texture)
            pl:SetVerticalFOV(self.metadata.Exterior.ProjectedLight.vertfov or self.metadata.Exterior.Portal.height)
            pl:SetHorizontalFOV(self.metadata.Exterior.ProjectedLight.horizfov or self.metadata.Exterior.Portal.width+10)
            pl:SetEnableShadows(true)
            pl:SetPos(self:LocalToWorld(Vector(-110.811, 19.174, 138.526)))
            pl:SetColor(Color(255,255,255))
            pl:SetFarZ(100)
            pl:SetAngles(Angle(0,0,0))
            pl:SetBrightness(100)
            pl:Update()
            tardisdebug("PL")]]
    
            local lamp = MakeLamp(self:GetCreator(),
                    255, 255, 255, KEY_NONE, true,
                    "effects/flashlight/soft",
                    "models/maxofs2d/lamp_projector.mdl",
                    9920, 1024, 4, true,
                    {
                        Pos = self:LocalToWorld(Vector(-110.811, 19.174, 138.526)),
                        Angle = Angle(0,0,0),
                    })

            lamp:SetRenderMode(RENDERMODE_TRANSALPHA)
            lamp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
            lamp:SetUnFreezable(false)
            lamp:GetPhysicsObject():EnableMotion(false)
            lamp:SetColor(Color(255,255,0,0))
        end)
    end


end