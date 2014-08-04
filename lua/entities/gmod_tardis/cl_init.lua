include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	if WireLib then
		Wire_Render(self)
	end
end

function ENT:Initialize()
	self:CallHook("Initialize")
end

function ENT:Think()
	self:CallHook("Think")
end