include('shared.lua')

function ENT:Draw()
	if self:CallHook("ShouldDraw") then
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
