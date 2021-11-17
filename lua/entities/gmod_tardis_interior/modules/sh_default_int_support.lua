-- Default interior support

if SERVER then
	local function playerlookingat(self,ply,vec,fov,width)	
		local disp = vec - self:WorldToLocal(ply:GetPos()+Vector(0,0,64))
		local dist = disp:Length()
		
		local maxcos = math.abs( math.cos( math.acos( dist / math.sqrt( dist * dist + width * width ) ) + fov * ( math.pi / 180 ) ) )
		disp:Normalize()
		
		if disp:Dot( ply:EyeAngles():Forward() ) > maxcos then
			return true
		end
		
		return false
	end

	ENT:AddHook("Use", "interior-default", function(self,a,c)
		if self.metadata.ID=="default" and a:IsPlayer() and (not a:GetTardisData("outside")) and CurTime()>a:GetTardisData("outsidecool",0) then
			local pos=Vector(0,0,0)
			local pos2=self:WorldToLocal(a:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 110 and playerlookingat(self,a,pos,10,10) then
				TARDIS:Control("thirdperson", a)
			end
		end
	end)
end

ENT:AddHook("Initialize", "interior-default", function(self)
	if self.metadata.ID=="default" then
		self.timerotor={}
		self.timerotor.pos=0
		self.timerotor.mode=1
	end
end)

ENT:AddHook("Think", "interior-default", function(self)
	if self.metadata.ID=="default" then
		local moving = self.exterior:GetData("teleport",false)
		local flightmode = self.exterior:GetData("flight",false)
		if not CLIENT then return end
		if (self.timerotor.pos>0 and not moving or flightmode) or (moving or flightmode) then
		if self.timerotor.pos==1 then
			self.timerotor.mode=0
		elseif self.timerotor.pos==0 and (moving or flightmode) then
			self.timerotor.mode=1
		end
		self.timerotor.pos=math.Approach( self.timerotor.pos, self.timerotor.mode, FrameTime()*1.1 )
		self:SetPoseParameter( "glass", self.timerotor.pos )
		end
	end
end)
