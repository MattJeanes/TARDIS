-- Stops people unfreezing the interior

ENT:AddHook("Initialize", "freeze", function(self)
	self.freeze=true
end)

hook.Add("PhysgunPickup", "tardis-freeze", function(ply,ent)
	if ent.freeze then return false end
end)

hook.Add("PhysgunPickup", "tardis-freeze", function(ply,ent)
	if ent.freeze then return false end
end)

hook.Add("PlayerUnfrozeObject", "tardis-freeze", function(ply,ent,phys)
	if ent.freeze then phys:EnableMotion(false) end
end)