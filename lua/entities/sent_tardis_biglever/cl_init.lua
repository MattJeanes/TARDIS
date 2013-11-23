include('shared.lua')

function ENT:Draw()
	if LocalPlayer().tardis==self:GetNWEntity("TARDIS", NULL) and LocalPlayer().tardis_viewmode and not LocalPlayer().tardis_render then
		self:DrawModel()
	end
end

function ENT:Initialize()
	self.PosePosition = 0.5
end

function ENT:Think()
	if LocalPlayer().tardis==self:GetNWEntity("TARDIS", NULL) and LocalPlayer().tardis_viewmode then
		local TargetPos = 0.0;
		if ( self:GetOn() ) then TargetPos = 1.0; end
		self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 1.25 )
		self:SetPoseParameter( "switch", self.PosePosition )
		self:InvalidateBoneCache()
		
		if LocalPlayer():GetEyeTraceNoCursor().Entity==self and LocalPlayer():EyePos():Distance(self:GetPos())<85 then
			if tobool(GetConVarNumber("tardisint_tooltip"))==true then
				AddWorldTip( self:EntIndex(), "Fast-Return Protocol", 0.5, self:GetPos(), self.Entity  )
			end
			effects.halo.Add( {self}, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )
		end
	end
end