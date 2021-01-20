--Fake light bleeding

--Settings

TARDIS:AddSetting({
	id="extprojlight-enabled",
	name="Door Light Enabled",
	section="Misc",
	desc="Should light shine out through the doors when they're open?",
	value=true,
	type="bool",
	option=true,
})

--Methods

function ENT:CalcLightBrightness(pos)
	local lightcolour = render.GetLightColor(pos):ToColor()
	local rm = 0.299*lightcolour.r
	local gm = 0.587*lightcolour.g
	local bm = 0.114*lightcolour.b
	local luminance = rm + gm + bm
	return luminance
end

function ENT:PickProjectedLightColour()
	local warning = self:GetData("health-warning",false)
	local color = self.metadata.Exterior.ProjectedLight.color or self.metadata.Interior.Light.color
	local warncolor = self.metadata.Exterior.ProjectedLight.warncolor or self.metadata.Interior.Light.warncolor
	local pickedcolour = warning and (warncolor or color) or color
	return pickedcolour
end

function ENT:CreateProjectedLight()
	if self.projectedlight then return end
	local pl = ProjectedTexture()
	self:SetData("pl-warning",self:GetData("health-warning"))
	pl:SetTexture(self.metadata.Exterior.ProjectedLight.texture)
	pl:SetFarZ(self.metadata.Exterior.ProjectedLight.farz)
	pl:SetVerticalFOV(self.metadata.Exterior.ProjectedLight.vertfov or self.metadata.Exterior.Portal.height)
	pl:SetHorizontalFOV(self.metadata.Exterior.ProjectedLight.horizfov or self.metadata.Exterior.Portal.width+10)
	pl:SetBrightness(self.metadata.Exterior.ProjectedLight.brightness)
	pl:SetEnableShadows(true)
	pl:SetColor(self:PickProjectedLightColour())
	self.projectedlight = pl
end

function ENT:RemoveProjectedLight()
	if self.projectedlight then
		self.projectedlight:Remove()
		self.projectedlight = nil
	end
end

function ENT:UpdateProjectedLight()
	if not IsValid(self.projectedlight) or not self.projectedlight then return end
	local warning = self:GetData("health-warning",false)
	if warning~=self:GetData("pl-warning",false) then
		local color = self:PickProjectedLightColour()
		self:SetData("pl-warning",warning)
		self.projectedlight:SetColor(color)
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