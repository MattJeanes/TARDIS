include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
	self.interior=self:GetInterior(net.ReadString())
end)