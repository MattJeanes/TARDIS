-- Helper functions

function TARDIS:GetExterior(ply)
	return (CLIENT and LocalPlayer() or ply):GetTardisData("exterior")
end

function TARDIS:GetInterior(ply)
	return (CLIENT and LocalPlayer() or ply):GetTardisData("interior")
end