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
	local luminance = rm + gm + rm
	return luminance
end

function ENT:CreateProjectedLight()
	if self.projectedlight then return end
	local pl = ProjectedTexture()
	pl:SetTexture("effects/flashlight/square")
	pl:SetFarZ(250)
	pl:SetVerticalFOV(self.metadata.Exterior.Portal.height)
	pl:SetHorizontalFOV(self.metadata.Exterior.Portal.width+10)
	pl:SetColor(self.metadata.Interior.Light.color)
    pl:SetBrightness(0.5)
    pl:SetPos(self:LocalToWorld(Vector(-21,0,51.1)))
    pl:SetEnableShadows(true)
	pl:SetAngles(self:GetAngles())
	pl:Update()
	self.projectedlight = pl
end

function ENT:RemoveProjectedLight()
	if self.projectedlight then
		self.projectedlight:Remove()
		self.projectedlight = nil
	end
end

function ENT:UpdateProjectedLight()
    self.projectedlight:SetPos(self:LocalToWorld(Vector(-21,0,51.1)))
    self.projectedlight:SetAngles(self:GetAngles())
    self.projectedlight:Update()
end
--Hooks
ENT:AddHook("OnRemove", "projectedlight", function(self)
	if ( IsValid( self.projectedlight ) ) then
		self.projectedlight:Remove()
	end
end)

ENT:AddHook("ShouldDrawProjectedLight", "baseShouldDraw", function(self)
	return self:DoorOpen(true)
end)

ENT:AddHook("ShouldNotDrawProjectedLight","baseShouldntDraw",function(self)
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
        else
            self:UpdateProjectedLight()
        end
    elseif self.projectedlight then
        self:RemoveProjectedLight()
    end
end)