-- Legacy interior support

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

ENT:AddHook("Use", "interior-legacy", function(self,a,c)
	if self.metadata.ID=="legacy" and a:IsPlayer() and (not a:GetTardisData("thirdperson")) and CurTime()>a:GetTardisData("thirdpersoncool",0) then
		local pos=Vector(0,0,0)
		local pos2=self:WorldToLocal(a:GetPos())
		local distance=pos:Distance(pos2)
		if distance < 110 and playerlookingat(self,a,pos,10,10) then
			self.exterior:PlayerThirdPerson(a,true)
		end
	end
end)