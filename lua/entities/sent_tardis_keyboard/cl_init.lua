include('shared.lua')

function ENT:Draw()
	if LocalPlayer().tardis==self:GetNWEntity("TARDIS", NULL) and LocalPlayer().tardis_viewmode then
		self:DrawModel()
	end
end

function ENT:Think()
	if LocalPlayer():GetEyeTraceNoCursor().Entity==self and LocalPlayer():EyePos():Distance(self:GetPos())<60 then
		if tobool(GetConVarNumber("tardisint_tooltip"))==true then
			AddWorldTip( self:EntIndex(), "Navigations Mode", 0.5, self:GetPos(), self.Entity  )
		end
		effects.halo.Add( {self}, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )
	end
end