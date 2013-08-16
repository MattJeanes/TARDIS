include('shared.lua')

function ENT:Draw()
	if LocalPlayer().tardis==self:GetNWEntity("TARDIS", NULL) and LocalPlayer().tardis_viewmode then
		self:DrawModel()
	end
end

function ENT:Initialize()
	self.PosePosition = 0.5
end

function ENT:Think()
	local tardis=self:GetNWEntity("TARDIS", NULL)
	if IsValid(tardis) and LocalPlayer().tardis==tardis and LocalPlayer().tardis_viewmode and tardis.power then
		local TargetPos
		if ( self:GetDir() ) then
			TargetPos = 1.0
			if self.PosePosition==1 then
				self.PosePosition=0
			end
		else
			TargetPos = 0.0
			if self.PosePosition==0 then
				self.PosePosition=1
			end
		end
		self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 1 )
		self:SetPoseParameter( "switch", self.PosePosition )
		self:InvalidateBoneCache()
		
		if LocalPlayer():GetEyeTraceNoCursor().Entity==self and LocalPlayer():EyePos():Distance(self:GetPos())<60 then
			if tobool(GetConVarNumber("tardisint_tooltip"))==true then
				AddWorldTip( self:EntIndex(), "Helmic Regulator", 0.5, self:GetPos(), self.Entity  )
			end
			effects.halo.Add( {self}, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )
		end
	end
end