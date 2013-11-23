include('shared.lua')

function ENT:Draw()
	if LocalPlayer().tardis==self:GetNWEntity("TARDIS", NULL) and LocalPlayer().tardis_viewmode and not LocalPlayer().tardis_render then
		self:DrawModel()
	end
end