include('shared.lua')

function ENT:DrawTranslucent()
	self:DrawModel()
	if WireLib then
		Wire_Render(self)
	end
end

function ENT:Draw() end

function ENT:Initialize()
	self:CallHook("Initialize")
end