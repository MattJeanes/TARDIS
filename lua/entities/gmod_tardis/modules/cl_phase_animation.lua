
local function dodraw(self, ent)
	ent = ent or self
	local animating = (self:CallHook("ShouldDrawPhaseAnimation") == true)
	if animating and not wp.drawing then
		ent:SetRenderClipPlaneEnabled(true)
	else
		ent:SetRenderClipPlaneEnabled(false)
		return
	end
	oldClip = render.EnableClipping(true)
	local restoreT = ent:GetMaterial()

	local normal = self:GetUp()
	local pos = self:GetData("phase-highPos",Vector(0,0,0))
	local dist = normal:Dot(pos)

	local normal2 = self:GetUp() * -1
	local pos2 = self:GetData("phase-pos",Vector(0,0,0))
	local dist2 = normal2:Dot(pos2)

	ent:SetRenderClipPlane(normal, dist)

	render.PushCustomClipPlane(normal, dist)
	render.MaterialOverride(self.PhaseMaterial)

	render.PushCustomClipPlane(normal2, dist2)
		ent:DrawModel()
	render.PopCustomClipPlane()
	render.PopCustomClipPlane()

	render.MaterialOverride(restoreT)
end

local function postdraw()
	if not (self:CallHook("ShouldDrawPhaseAnimation") == true) then return end
	render.EnableClipping(oldClip)
end

ENT:AddHook("Draw", "phase_animation", dodraw)

ENT:AddHook("PostDraw", "phase_animation", postdraw)

ENT:AddHook("DrawPart", "phase_animation", function(self,part)
	if part.NoCloak ~= true then
		dodraw(self,part)
	end
end)

ENT:AddHook("PostDrawPart", "phase_animation", function(self,part)
	if part.NoCloak ~= true then
		dodraw(self,part)
	end
end)