-- Stops people unfreezing the interior

ENT:AddHook("Initialize", "freeze", function(self)
	self.freeze=true
end)

hook.Add("PhysgunPickup", "tardis-freeze", function(self,ent)
	if ent.freeze then return false end
end)