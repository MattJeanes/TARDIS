AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("Player-SetTARDIS")
util.AddNetworkString("TARDIS-SetHealth")
util.AddNetworkString("TARDIS-Go")
util.AddNetworkString("TARDIS-Explode")
util.AddNetworkString("TARDIS-TakeDamage")

net.Receive("TARDIS-TakeDamage", function(len,ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		RunConsoleCommand("tardis_takedamage", net.ReadFloat())
	end
end)
 
function ENT:Initialize()
	self:SetModel( "models/tardis.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:Wake()
	end
	
	self.light = self:SpawnLight()
	self:SetLight(false)
	self.a=255 // alpha
	self.cur=0
	self.curdelay=0.01
	self.cycle=1
	self.step=1
	self.exitcur=0
	self.flightcur=0
	self.flightmode=false
	self.health=100
	self.exploded=false
	self.occupants={}
	if WireLib then
		self.wirepos=Vector(0,0,0)
		self.wireang=Angle(0,0,0)
		Wire_CreateInputs(self, { "Go", "X", "Y", "Z", "XYZ [VECTOR]", "Rot" })
	end
	
	self.dematvalues={
		{150,200},
		{100,150},
		{50,100}
	}
	self.matvalues={
		{100,50},
		{150,100},
		{200,150},
	}
end

function ENT:ShouldTakeDamage()
	return tobool(GetConVarNumber("tardis_takedamage"))==true
end

function ENT:Explode()
	self.exploded=true
	self:SetLight(false)
	
	net.Start("TARDIS-Explode")
		net.WriteEntity(self)
	net.Broadcast()
	
	self.fire = ents.Create("env_fire_trail")
	self.fire:SetPos(self:LocalToWorld(Vector(0,0,50)))
	self.fire:Spawn()
	self.fire:SetParent(self)
	
	self.smoke=self:CreateSmoke()
	
	local explode = ents.Create("env_explosion")
	explode:SetPos( self:LocalToWorld(Vector(0,0,50)) ) //Puts the explosion where you are aiming
	explode:SetOwner( self ) //Sets the owner of the explosion
	explode:Spawn()
	explode:SetKeyValue("iMagnitude","175") //Sets the magnitude of the explosion
	explode:Fire("Explode", 0, 0 ) //Tells the explode entity to explode
	//explode:EmitSound("weapon_AWP.Single", 400, 400 ) //Adds sound to the explosion
	
	self:SetColor(Color(255,190,0,255))
end

function ENT:CreateSmoke()
	local smoke = ents.Create("env_smokestack")
	smoke:SetPos(self:LocalToWorld(Vector(0,0,80)))
	smoke:SetAngles(self:GetAngles()+Angle(-90,0,0))
	smoke:SetKeyValue("InitialState", "1")
	smoke:SetKeyValue("WindAngle", "0 0 0")
	smoke:SetKeyValue("WindSpeed", "0")
	smoke:SetKeyValue("rendercolor", "50 50 50")
	smoke:SetKeyValue("renderamt", "170")
	smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
	smoke:SetKeyValue("BaseSpread", "2")
	smoke:SetKeyValue("SpreadSpeed", "2")
	smoke:SetKeyValue("Speed", "50")
	smoke:SetKeyValue("StartSize", "30")
	smoke:SetKeyValue("EndSize", "70")
	smoke:SetKeyValue("roll", "20")
	smoke:SetKeyValue("Rate", "15")
	smoke:SetKeyValue("JetLength", "40")
	smoke:SetKeyValue("twist", "5")
	smoke:Spawn()
	smoke:SetParent(self)
	smoke:Activate()
	return smoke
end

function ENT:SetHP(hp)
	if not hp or self.exploded or not self:ShouldTakeDamage() then return end
	if hp < 0 then hp=0 end
	net.Start("TARDIS-SetHealth")
		net.WriteEntity(self)
		net.WriteFloat(hp)
	net.Broadcast()
	self.health=hp
	if hp==0 then
		self:Explode()
	end
end

function ENT:TakeHP(hp)
	if not hp or not self:ShouldTakeDamage() then return end
	self:SetHP(self.health-hp)
end

function ENT:OnTakeDamage(dmginfo)
	if not self:ShouldTakeDamage() then return end
	local hp=dmginfo:GetDamage()
	self:TakeHP(hp/4)
end

function ENT:SetLight(on)
	if on and not self.exploded then
		self.light:Fire("showsprite","",0)
		self.light.on=true
	else
		self.light:Fire("hidesprite","",0)
		self.light.on=false
	end
end

function ENT:ToggleLight()
	if self.light.on then
		self:SetLight(false)
	else
		self:SetLight(true)
	end
end

function ENT:Teleport()
	if self.vec then
		self:GetPhysicsObject():EnableMotion(false)
		if self.attachedents then
			for k,v in pairs(self.attachedents) do
				if IsValid(v) and not IsValid(v:GetParent()) then
					local phys=v:GetPhysicsObject()
					if phys and IsValid(phys) then
						if not phys:IsMotionEnabled() then
							v.frozen=true
						end
						phys:EnableMotion(false)
					end
					v.telepos=v:GetPos()-self:GetPos()
				end
			end
		end
		self:SetPos(self.vec)
		if self.ang then
			self:SetAngles(self.ang)
		end
		if self.attachedents then
			for k,v in pairs(self.attachedents) do
				if IsValid(v) and not IsValid(v:GetParent()) then
					v:SetPos(self:GetPos()+v.telepos)
					v.telepos=nil
					local phys=v:GetPhysicsObject()
					if phys and IsValid(phys) and not v.frozen then
						phys:EnableMotion(true)
					end
					v.frozen=nil
				end
			end
		end
		self:GetPhysicsObject():EnableMotion(true)
	end
end

function ENT:GetNumber()
	if self.demat and not self.mat then
		return self.dematvalues[self.cycle][self.step]
	elseif self.mat and not self.demat then
		return self.matvalues[self.cycle][self.step]
	end
end

function ENT:Go(vec,ang)
	if not self.moving and vec and not self.exploded then
		self.demat=true
		self.moving=true
		self.vec=vec
		self.attachedents = constraint.GetAllConstrainedEntities(self)
		if self.attachedents then
			for k,v in pairs(self.attachedents) do
				local a=v:GetColor().a
				if not (a==255) then
					v.tempa=a
					print(v.tempa)
				end
			end
		end
		if ang then
			self.ang=ang
		end
		self:SetLight(true)
		net.Start("TARDIS-Go")
			net.WriteEntity(self)
			net.WriteVector(self:GetPos())
			net.WriteVector(self.vec)
		net.Broadcast()
	end
end

function ENT:Stop()
	if self.moving then
		self.cycle=1
		self.step=1
		self.mat=false
		self.moving=false
		self.vec=nil
		self.ang=nil
		if self.attachedents then
			for k,v in pairs(self.attachedents) do
				if v.tempa then
					local col=v:GetColor()
					col=Color(col.r,col.g,col.b,v.tempa)
					v:SetColor(col)
					v.tempa=nil
				end
			end
		end
		self.attachedents=nil
		if not self.flightmode then
			self:SetLight(false)
		end
	end
end

if WireLib then
	function ENT:TriggerInput(k,v)
		if k=="Go" and v==1 and self.wirepos and self.wireang and not self.moving then
			self:Go(self.wirepos, self.wireang)
		elseif k=="X" then
			self.wirepos.x=v
		elseif k=="Y" then
			self.wirepos.y=v
		elseif k=="Z" then
			self.wirepos.z=v
		elseif k=="XYZ" then
			self.wirepos=v
		elseif k=="Rot" then
			self.wireang.y=v
		end
	end
end

function ENT:Dematerialize()
	if self.cycle==1 then
		if self.step==1 and self.a > self:GetNumber() then
			self.a=self.a-1
		elseif self.step==1 and self.a == self:GetNumber() then
			self.step=2
		elseif self.step==2 and self.a < self:GetNumber() then
			self.a=self.a+1
		elseif self.step==2 and self.a == self:GetNumber() then
			self.cycle=2
			self.step=1
		end
	elseif self.cycle==2 then
		if self.step==1 and self.a > self:GetNumber() then
			self.a=self.a-1
		elseif self.step==1 and self.a == self:GetNumber() then
			self.step=2
		elseif self.step==2 and self.a < self:GetNumber() then
			self.a=self.a+1
		elseif self.step==2 and self.a == self:GetNumber() then
			self.cycle=3
			self.step=1
		end
	elseif self.cycle==3 then
		if self.step==1 and self.a > self:GetNumber() then
			self.a=self.a-1
		elseif self.step==1 and self.a == self:GetNumber() then
			self.step=2
		elseif self.step==2 and self.a < self:GetNumber() then
			self.a=self.a+1
		elseif self.step==2 and self.a == self:GetNumber() then
			self.cycle=4
			self.step=1
		end	
	elseif self.cycle==4 then
		if self.step==1 and self.a > 0 then
			self.a=self.a-1
		elseif self.step==1 and self.a==0 then
			self.cycle=1
			self.step=1
			self.demat=false
			self.mat=true
			self:Teleport()
		end
	end
	self:UpdateAlpha()
end

function ENT:Materialize()
	if self.cycle==1 then
		if self.step==1 and self.a < self:GetNumber() then
			self.a=self.a+1
		elseif self.step==1 and self.a == self:GetNumber() then
			self.step=2
		elseif self.step==2 and self.a > self:GetNumber() then
			self.a=self.a-1
		elseif self.step==2 and self.a == self:GetNumber() then
			self.cycle=2
			self.step=1
		end
	elseif self.cycle==2 then
		if self.step==1 and self.a < self:GetNumber() then
			self.a=self.a+1
		elseif self.step==1 and self.a == self:GetNumber() then
			self.step=2
		elseif self.step==2 and self.a > self:GetNumber() then
			self.a=self.a-1
		elseif self.step==2 and self.a == self:GetNumber() then
			self.cycle=3
			self.step=1
		end
	elseif self.cycle==3 then
		if self.step==1 and self.a < self:GetNumber() then
			self.a=self.a+1
		elseif self.step==1 and self.a == self:GetNumber() then
			self.step=2
		elseif self.step==2 and self.a > self:GetNumber() then
			self.a=self.a-1
		elseif self.step==2 and self.a == self:GetNumber() then
			self.cycle=4
			self.step=1
		end	
	elseif self.cycle==4 then
		if self.step==1 and self.a < 255 then
			self.a=self.a+1
		elseif self.step==1 and self.a==255 then
			self:Stop()
		end
	end
	self:UpdateAlpha()
end

function ENT:SpawnLight()
	// cheers to 'Doctor Who Dev Team' for this
	local light = ents.Create("env_sprite")
	light:SetPos(self:GetPos() + self:GetUp() * 113)
	light:SetAngles(self:GetAngles())
	light:SetKeyValue("renderfx", 4)
	light:SetKeyValue("rendermode", 3)
	light:SetKeyValue("renderamt", "200")
    light:SetKeyValue("rendercolor", "255 255 255")
    light:SetKeyValue("model", "sprites/light_glow02.spr")
    light:SetKeyValue("scale", 1)
	light:SetKeyValue("glowproxysize", 9)
    light:Spawn()
	light:SetParent(self)
	return light
end
 
function ENT:Use( ply, caller )
	if CurTime()>self.exitcur then
		if self.occupants then
			for k,v in pairs(self.occupants) do
				if ply==v then return end
			end
		end
		self.exitcur=CurTime()+1
		self:PlayerEnter(ply)
	end
end

function ENT:PlayerEnter( ply )
	net.Start("Player-SetTARDIS")
		net.WriteEntity(ply)
		net.WriteEntity(self)
	net.Broadcast()
	ply.tardis=self
	ply:Spectate( OBS_MODE_ROAMING )
	ply:DrawWorldModel(false)
	ply:DrawViewModel(false)
	ply.weps={}
	for k,v in pairs(ply:GetWeapons()) do
		table.insert(ply.weps, v:GetClass())
	end
	ply:StripWeapons()
	ply:CrosshairDisable(true)
	table.insert(self.occupants,ply)
	if #self.occupants==1 then
		self.pilot=ply
	end
end

function ENT:OnRemove()
	if self.occupants then
		for k,v in pairs(self.occupants) do
			self:PlayerExit(v)
		end
	end
	self.light:Remove()
	self.light=nil
end

function ENT:PlayerExit( ply )
	net.Start("Player-SetTARDIS")
		net.WriteEntity(ply)
		net.WriteEntity(NULL)
	net.Broadcast()
	ply.tardis=nil
	ply:UnSpectate()
	ply:DrawViewModel(true)
	ply:DrawWorldModel(true)
	ply:Spawn()
	ply:CrosshairDisable(false)
	ply:CrosshairEnable(true)
	if ply.weps then
		for k,v in pairs(ply.weps) do
			ply:Give(tostring(v))
		end
	end
	ply:SetPos(self:GetPos()+self:GetForward()*75)
	ply:SetEyeAngles((self:GetPos()-ply:GetPos()):Angle()) // make you face the tardis
	if self.occupants then
		for k,v in pairs(self.occupants) do
			if v==ply then
				self.occupants[k]=nil
			end
		end
	end
	if self.pilot and self.pilot==ply then
		self.pilot=nil
	end
end

hook.Add("PlayerSpawn", "TARDIS_PLDeath", function( ply )
	timer.Simple(0.1,function()
		local tardis=ply.tardis
		if tardis and IsValid(tardis) then
			tardis:PlayerExit(ply)
		end
	end)
end)

function ENT:UpdateAlpha()
	// utility functions!
	local maincol=self:GetColor()
	maincol=Color(maincol.r,maincol.g,maincol.b,self.a)
	self:SetColor(maincol)
	if self.attachedents then
		for k,v in pairs(self.attachedents) do
			if IsValid(v) then
				local col=v:GetColor()
				col=Color(col.r,col.g,col.b,self.a)
				if not (v.tempa==0) then
					if not (v:GetRenderMode()==RENDERMODE_TRANSALPHA) then
						v:SetRenderMode(RENDERMODE_TRANSALPHA)
					end
					v:SetColor(col)
				end
			end
		end
	end
end

function ENT:PhysicsUpdate( ph )
	local pos=self:GetPos()
	
	if self.flightmode then		
		local phm=FrameTime()*66
		
		local up=self:GetUp()
		local ri2=self:GetRight()
		local fwd2=self:GetForward()
		local ang=self:GetAngles()
		local force=15
		local vforce=5
		local tilt=0
		
		if self.pilot and not self.exploded then
			local p=self.pilot
			local eye=p:EyeAngles()
			local fwd=eye:Forward()
			local ri=eye:Right()
			if p:KeyDown(IN_SPEED) then
				force=force*2
				tilt=5
			end
			if p:KeyDown(IN_FORWARD) then
				ph:AddVelocity(fwd*force*phm)
				tilt=tilt+5
			end
			if p:KeyDown(IN_BACK) then
				ph:AddVelocity(-fwd*force*phm)
				tilt=tilt+5
			end	
			if p:KeyDown(IN_MOVERIGHT) then
				ph:AddVelocity(ri*force*phm)
				tilt=tilt+5
			end
			if p:KeyDown(IN_MOVELEFT) then
				ph:AddVelocity(-ri*force*phm)
				tilt=tilt+5
			end
			
			if p:KeyDown(IN_DUCK) then
				ph:AddVelocity(-up*vforce*phm)
			elseif p:KeyDown(IN_JUMP) then
				ph:AddVelocity(up*vforce*phm)
			end
		end
		
		if not self.exploded then
			local cen=ph:GetMassCenter()
			local lev=ph:GetInertia():Length()
			ph:ApplyForceOffset( up*-ang.p,cen-fwd2*lev)
			ph:ApplyForceOffset(-up*-ang.p,cen+fwd2*lev)
			//ph:ApplyForceOffset( ri2*-ang2.y,cen-fwd2*lev)
			//ph:ApplyForceOffset(-ri2*-ang2.y,cen+fwd2*lev)
			ph:ApplyForceOffset( up*-(ang.r-tilt),cen-ri2*lev)
			ph:ApplyForceOffset(-up*-(ang.r-tilt),cen+ri2*lev)
		end
		
		if not self.exploded then
			local twist=Vector(0,0,ph:GetVelocity():Length()/400)
			ph:AddAngleVelocity(twist)
			local angbrake=ph:GetAngleVelocity()*-0.01
			ph:AddAngleVelocity(angbrake)
			local brake=self:GetVelocity()*-0.01
			ph:AddVelocity(brake)
		elseif self.exploded and ph:GetVelocity():Length()<1500 then
			local speed=ph:GetVelocity()*0.01
			ph:AddVelocity(speed)
			
			local angle=AngleRand():Forward()*75
			ph:AddAngleVelocity(angle)
		end
	end
	
	if self.occupants then
		for k,v in pairs(self.occupants) do
			v:SetPos(pos)
		end
	end
end

function ENT:ToggleFlight()
	self.flightmode=(not self.flightmode)
	if self.flightmode then //on
		if self.phys and IsValid(self.phys) then
			self.phys:EnableGravity(false)
		end
		self:SetLight(true)
		self:SetNWBool("flightmode", true)
		if !self.RotorWash then
			self.RotorWash = ents.Create("env_rotorwash_emitter")
			self.RotorWash:SetPos(self:GetPos())
			self.RotorWash:SetParent(self)
			self.RotorWash:Activate()
		end		
	else //off
		if self.phys and IsValid(self.phys) then
			self.phys:EnableGravity(true)
		end
		if not self.moving then
			self:SetLight(false)
		end
		self:SetNWBool("flightmode", false)
		if self.RotorWash and not self.moving then
			self.RotorWash:Remove()
			self.RotorWash = nil
		end
	end
end

function ENT:Think()
	if CurTime() > self.cur then
		if self.demat then
			self:Dematerialize()
		elseif self.mat then
			self:Materialize()
		end
		self.cur=CurTime()+self.curdelay
	end

	if self.occupants then
		for k,v in pairs(self.occupants) do
			if CurTime()>self.exitcur and v:KeyDown(IN_USE) then
				self.exitcur=CurTime()+1
				self:PlayerExit(v)
			end
		end
	end
	
	if self.moving then
		local a1=self:GetPos()
		for k,v in pairs(ents.FindInSphere(self:GetPos(),150)) do
			if v:GetClass()=="prop_physics" then
				local a2=v:GetPos()
				local force=5
				local vec=a2-a1
				vec:Normalize()
				v:GetPhysicsObject():AddVelocity(vec*force)
			end
		end
		if !self.RotorWash then
			self.RotorWash = ents.Create("env_rotorwash_emitter")
			self.RotorWash:SetPos(self:GetPos())
			self.RotorWash:SetParent(self)
			self.RotorWash:Activate()
		end
	else
		if self.RotorWash and not self.flightmode then
			self.RotorWash:Remove()
			self.RotorWash = nil
		end
	end
	
	if self.phys and IsValid(self.phys) then
		self.phys:Wake()
	end
	
	if CurTime() > self.flightcur and self.pilot and IsValid(self.pilot) and self.pilot:KeyDown(IN_RELOAD) then
		self.flightcur=CurTime()+1
		self:ToggleFlight()
		if self.flightmode then
			self.pilot:ChatPrint("Flight-mode activated.")
		else
			self.pilot:ChatPrint("Flight-mode deactivated.")
		end
	end
	
	// this bit makes it all run faster and smoother
    self:NextThink( CurTime() )
	return true
end