include('shared.lua')

function ENT:Draw()
	if self:CallHook("ShouldDraw") then
		self:CallHook("PreDraw")
		self:DrawModel()
		if WireLib then
			Wire_Render(self)
		end
		self:CallHook("Draw")
	end
end

function ENT:Initialize()
	self:CallHook("Initialize")
end

function ENT:Think()
	self:CallHook("Think")
end

hook.Add("PostDrawTranslucentRenderables", "TARDIS", function(...)
	for k,v in pairs(ents.FindByClass("gmod_tardis_interior")) do
		v:CallHook("PostDrawTranslucentRenderables",...)
	end
end)