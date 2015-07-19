-- Stops people unfreezing the interior and parts

hook.Add("PhysgunPickup", "tardis-freeze", function(ply,ent)
	if ent.TardisPart then return false end
end)

hook.Add("PlayerUnfrozeObject", "tardis-freeze", function(ply,ent,phys)
	if ent.TardisPart then phys:EnableMotion(false) end
end)