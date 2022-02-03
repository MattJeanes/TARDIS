--Fake light bleeding

--Settings

TARDIS:AddSetting({
    id="extprojlight-enabled",
    name="Light Enabled",
    section="Exterior Door",
    desc="Should light shine out through the doors when they're open?",
    value=true,
    type="bool",
    option=true,
})

TARDIS:AddSetting({
    id="extprojlight-brightness-override",
    name="Light Brightness Override",
    section="Exterior Door",
    desc="Override brightness of light, reset for default",
    value=false,
    type="number",
    min=0,
    max=10,
    option=true,
})

TARDIS:AddSetting({
    id="extprojlight-distance-override",
    name="Light Distance Override",
    section="Exterior Door",
    desc="Override distance of light, reset for default",
    value=false,
    min=0,
    max=5000,
    type="number",
    option=true,
})

TARDIS:AddSetting({
    id="extprojlight-color-override",
    name="Light Color Override",
    section="Exterior Door",
    desc="Override color of light, reset for default",
    value=false,
    type="color",
    option=true,
})

--Methods

function ENT:CalcLightBrightness(pos)
    local lightcolor = render.GetLightColor(pos):ToColor()
    local rm = 0.299*lightcolor.r
    local gm = 0.587*lightcolor.g
    local bm = 0.114*lightcolor.b
    local luminance = rm + gm + bm
    return luminance
end

function ENT:PickProjectedLightColor()
    local override = TARDIS:GetSetting("extprojlight-color-override")
    if override then return override end
    local warning = self:GetData("health-warning",false)
    local color = self.metadata.Exterior.ProjectedLight.color or self.metadata.Interior.Light.color
    local warncolor = self.metadata.Exterior.ProjectedLight.warncolor or self.metadata.Interior.Light.warncolor
    local pickedcolor = warning and (warncolor or color) or color
    return pickedcolor
end

function ENT:PickProjectedLightBrightness()
    return TARDIS:GetSetting("extprojlight-brightness-override") or self.metadata.Exterior.ProjectedLight.brightness
end

function ENT:PickProjectedLightDistance()
    return TARDIS:GetSetting("extprojlight-distance-override") or self.metadata.Exterior.ProjectedLight.farz
end

function ENT:CreateProjectedLight()
    if self.projectedlight then return end
    local pl = ProjectedTexture()
    pl:SetTexture(self.metadata.Exterior.ProjectedLight.texture)
    pl:SetVerticalFOV(self.metadata.Exterior.ProjectedLight.vertfov or self.metadata.Exterior.Portal.height)
    pl:SetHorizontalFOV(self.metadata.Exterior.ProjectedLight.horizfov or self.metadata.Exterior.Portal.width+10)
    pl:SetEnableShadows(true)
    self.projectedlight = pl
end

function ENT:RemoveProjectedLight()
    self:SetData("pl-color",nil)
    self:SetData("pl-brightness",nil)
    self:SetData("pl-distance",nil)
    if self.projectedlight then
        self.projectedlight:Remove()
        self.projectedlight = nil
    end
end

function ENT:UpdateProjectedLight()
    if not IsValid(self.projectedlight) or not self.projectedlight then return end
    local color = self:PickProjectedLightColor()
    if color~=self:GetData("pl-color",false) then
        self:SetData("pl-color",color)
        self.projectedlight:SetColor(color)
    end
    local brightness = self:PickProjectedLightBrightness()
    if brightness~=self:GetData("pl-brightness",false) then
        self:SetData("pl-brightness",brightness)
        self.projectedlight:SetBrightness(brightness)
    end
    local distance = self:PickProjectedLightDistance()
    if distance~=self:GetData("pl-distance",false) then
        self:SetData("pl-distance",distance)
        self.projectedlight:SetFarZ(distance)
    end
    self.projectedlight:SetPos(self:LocalToWorld(self.metadata.Exterior.ProjectedLight.offset))
    self.projectedlight:SetAngles(self:GetAngles())
    self.projectedlight:Update()
end

--Hooks

ENT:AddHook("OnRemove", "projectedlight", function(self)
    if IsValid(self.projectedlight) then
        self.projectedlight:Remove()
    end
end)

ENT:AddHook("ShouldDrawProjectedLight", "projectedlight", function(self)
    return self:DoorOpen(true)
end)

ENT:AddHook("ShouldNotDrawProjectedLight","projectedlight",function(self)
    if (not TARDIS:GetSetting("extprojlight-enabled")) or (not self.interior) then return true end
    if self:GetData("vortex",false)==true then return true end
    if not self.metadata.Interior.Light then return true end
end)

ENT:AddHook("Think", "projectedlight", function(self)
    if not self.interior then return end
    local shouldon = self:CallHook("ShouldDrawProjectedLight")
    local shouldoff = self:CallHook("ShouldNotDrawProjectedLight")

    if shouldon and (not shouldoff) then
        if (not self.projectedlight) or (not IsValid(self.projectedlight)) then
            self:CreateProjectedLight()
        end
        self:UpdateProjectedLight()
    elseif self.projectedlight then
        self:RemoveProjectedLight()
    end
end)