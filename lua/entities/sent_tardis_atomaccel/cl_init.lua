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
	local tardis=self:GetNWEntity("TARDIS", NULL)
	if IsValid(tardis) and LocalPlayer().tardis==tardis and LocalPlayer().tardis_viewmode then
		local mode=self:GetMode()
		if (tardis.flightmode or tardis.moving) and not (mode==0) then
			local TargetPos
			if ( mode==-1 ) then
				TargetPos = 1.0
				if self.PosePosition==1 then
					self.PosePosition=0
				end
			elseif ( mode==1 ) then
				TargetPos = 0.0
				if self.PosePosition==0 then
					self.PosePosition=1
				end
			end
			self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 1 )
			self:SetPoseParameter( "switch", self.PosePosition )
			self:InvalidateBoneCache()
		end
		
		if LocalPlayer():GetEyeTraceNoCursor().Entity==self and LocalPlayer():EyePos():Distance(self:GetPos())<60 then
			if tobool(GetConVarNumber("tardisint_tooltip"))==true then
				AddWorldTip( self:EntIndex(), "Atom Accelerator", 0.5, self:GetPos(), self.Entity  )
			end
			self.shouldglow=true
		else
			self.shouldglow=false
		end
	end
end