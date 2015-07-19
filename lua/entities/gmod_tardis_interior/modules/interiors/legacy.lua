-- Legacy

local INT={}
INT.Name="Legacy"
INT.ID="legacy"
INT.Model="models/drmatt/tardis/interior.mdl"
INT.IdleSound={
	{
		path="tardis/interior_idle_loop.wav",
		volume=0.5	
	},
	{
		path="tardis/interior_idle2_loop.wav",
		volume=0.5	
	}
}
INT.Light={
	color=Color(255,50,0),
	pos=Vector(0,0,120),
	brightness=5
}
INT.ScreenX=443
INT.ScreenY=335
INT.Portal={
	pos=Vector(316.7,334.9,-36.5),
	ang=Angle(0,230,0),
	width=45,
	height=91
}
INT.Fallback={
	pos=Vector(291,305,-75),
	ang=Angle(0,50,0)
}
INT.Screens={
	{
		pos=Vector(41.1,-13,47),
		ang=Angle(0,84.5,90)
	}
}
INT.Parts={
	door={
		pos=Vector(300,315,-88.1),
		ang=Angle(0,50,0)
	},
	rails={}
}

ENT:AddInterior(INT)

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
	if self.interior.ID==INT.ID and a:IsPlayer() and (not a:GetTardisData("thirdperson")) and CurTime()>a:GetTardisData("thirdpersoncool",0) then
		local pos=Vector(0,0,0)
		local pos2=self:WorldToLocal(a:GetPos())
		local distance=pos:Distance(pos2)
		if distance < 110 and playerlookingat(self,a,pos,10,10) then
			self.exterior:PlayerThirdPerson(a,true)
		end
	end
end)