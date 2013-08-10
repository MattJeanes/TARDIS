AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("Player-SetTARDIS")
util.AddNetworkString("TARDIS-SetHealth")
util.AddNetworkString("TARDIS-Go")
util.AddNetworkString("TARDIS-Stop")
util.AddNetworkString("TARDIS-Explode")
util.AddNetworkString("TARDIS-UnExplode")
util.AddNetworkString("TARDIS-Flightmode")
util.AddNetworkString("TARDIS-TakeDamage")
util.AddNetworkString("TARDIS-FlightPhase")
util.AddNetworkString("TARDIS-DoubleTrace")
util.AddNetworkString("TARDIS-SpawnOffset")
util.AddNetworkString("TARDIS-Phase")
util.AddNetworkString("TARDIS-UpdateVis")
util.AddNetworkString("TARDIS-SetInterior")
util.AddNetworkString("TARDIS-SetViewmode")
util.AddNetworkString("TARDIS-PlayerEnter")
util.AddNetworkString("TARDIS-PlayerExit")
util.AddNetworkString("TARDIS-SetLocked")
util.AddNetworkString("TARDIS-SetRepairing")
util.AddNetworkString("TARDIS-BeginRepair")
util.AddNetworkString("TARDIS-FinishRepair")
util.AddNetworkString("TARDIS-SetLight")

net.Receive("TARDIS-TakeDamage", function(len,ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		RunConsoleCommand("tardis_takedamage", net.ReadFloat())
	end
end)

net.Receive("TARDIS-FlightPhase", function(len,ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		RunConsoleCommand("tardis_flightphase", net.ReadFloat())
	end
end)

net.Receive("TARDIS-DoubleTrace", function(len,ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		RunConsoleCommand("tardis_doubletrace", net.ReadFloat())
	end
end)

net.Receive("TARDIS-SpawnOffset", function(len,ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		RunConsoleCommand("tardis_spawnoffset", net.ReadFloat())
	end
end)

//make the player name invisible while tardis is invisible
hook.Add("EV_ShowPlayerName", "TARDIS-EV_ShowPlayerName", function(ply)
	if ply.tardis and IsValid(ply.tardis) and not ply.tardis.visible then
		return false
	end
end)

//stop pewpew damaging when main damage is off
hook.Add("PewPew_ShouldDamage","TARDIS-PewPew_ShouldDamage",function(_,ent,dmg)
	if ent and IsValid(ent) and ent:GetClass()=="sent_tardis" then
		if ent:ShouldTakeDamage() then
			ent:TakeHP(dmg/32)
		end
		return false
	end
end)
 
function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/exterior.mdl" )
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
	self.visible=true
	self.locked=false
	self.phasecur=0
	self.interiorcur=0
	self.viewmodecur=0
	self.repaircur=0
	self.repairdelay=1
	self.occupants={}
	if WireLib then
		self.wirepos=Vector(0,0,0)
		self.wireang=Angle(0,0,0)
		Wire_CreateInputs(self, { "Demat", "Phase", "Flightmode", "X", "Y", "Z", "XYZ [VECTOR]", "Rot" })
		Wire_CreateOutputs(self, { "Health" })
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
	
	// this is a bit hacky but from testing it seems to work well
	local trdata={}
	trdata.start=self:GetPos()+Vector(0,0,99999999)
	trdata.endpos=self:GetPos()
	trdata.filter={self}
	local trace=util.TraceLine(trdata)
	//another trace is run here incase the mapper has placed the 3d skybox above the map
	if tobool(GetConVarNumber("tardis_doubletrace"))==true then
		local trdata={}
		trdata.start=trace.HitPos+Vector(0,0,-6000)
		trdata.endpos=trace.HitPos
		trdata.filter={self}
		trace=util.TraceLine(trdata)
		//this trace can sometimes fail if the map has a low skybox
	end
	local offset=0
	if GetConVarNumber("tardis_spawnoffset")>0 then
		offset=GetConVarNumber("tardis_spawnoffset")
	end
	self.interior=ents.Create("sent_tardis_interior")
	self.interior:SetPos(trace.HitPos+Vector(0,0,-600+offset))
	self.interior.tardis=self
	self.interior:Spawn()
	self.interior:Activate()
	self:SetNWEntity("interior",self.interior)
	self:SetHP(100)
	
	net.Start("TARDIS-SetInterior")
		net.WriteEntity(self)
		net.WriteEntity(self.interior)
	net.Broadcast()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:StartRepair()
	if self.repairing then return end
	if self.health > 99 then return end
	self.repairing=true
	net.Start("TARDIS-SetRepairing")
		net.WriteEntity(self)
		net.WriteBit(true)
		if IsValid(self.interior) then
			net.WriteEntity(self.interior)
		end
	net.Broadcast()
	self.repairwait=true
	self.repairoccupants=table.Copy(self.occupants)
	for k,v in pairs(self.occupants) do
		v:ChatPrint("TARDIS self-repair initiated, all occupants must exit to start.")
	end
end

function ENT:BeginRepair()
	self.repairwait=nil
	self.repairfinish=CurTime()+((100-self.health)*self.repairdelay)
	net.Start("TARDIS-BeginRepair")
		net.WriteEntity(self)
	net.Broadcast()
end

function ENT:EndRepair(completed)
	if not self.repairing then return end
	if self.repairoccupants then
		for k,v in pairs(self.repairoccupants) do
			if self.repairwait then
				v:ChatPrint("TARDIS self-repair cancelled.")
			else
				v:ChatPrint("TARDIS self-repair completed.")
			end
		end
		self.repairoccupants=nil
	end
	if completed then
		net.Start("TARDIS-FinishRepair")
			net.WriteEntity(self)
		net.Broadcast()
		self:FlashLight(1.5)
		self:SetHP(100)
	end
	self.repairing=nil
	self.repairwait=nil
	self.repairfinish=nil
	net.Start("TARDIS-SetRepairing")
		net.WriteEntity(self)
		net.WriteBit(false)
	net.Broadcast()
end

function ENT:SetLocked(locked)
	if locked then
		self.locked=true
	else
		self.locked=false
	end
	if self.visible and not self.exploded then
		net.Start("TARDIS-SetLocked")
			net.WriteEntity(self)
			net.WriteEntity(self.interior or NULL)
			net.WriteBit(self:GetLocked())
		net.Broadcast()
		self:FlashLight(0.5)
	end
end

function ENT:ToggleLocked()
	self:SetLocked(not self:GetLocked())
	return self:GetLocked()
end

function ENT:GetLocked()
	return self.locked
end

function ENT:ShouldTakeDamage()
	return tobool(GetConVarNumber("tardis_takedamage"))==true
end

function ENT:Explode()
	if not self:ShouldTakeDamage() then return end
	
	if not self.visible then
		self:TogglePhase()
	end
	
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
	
	self:SetColor(Color(255,190,0))
	
	if self.interior and IsValid(self.interior) then
		self.interior:Explode()
	end
end

function ENT:UnExplode()
	if not self:ShouldTakeDamage() then return end
	self.exploded=false
	if (self.moving or self.flightmode) and self.visible then
		self:SetLight(true)
	end
	
	net.Start("TARDIS-UnExplode")
		net.WriteEntity(self)
	net.Broadcast()
	
	if self.fire and IsValid(self.fire) then
		self.fire:Remove()
		self.fire=nil
	end
	
	if self.smoke and IsValid(self.smoke) then
		self.smoke:Remove()
		self.smoke=nil
	end
	
	self:SetColor(Color(255,255,255))
	
	if self.interior and IsValid(self.interior) then
		self.interior:UnExplode()
	end
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
	if not hp or not self:ShouldTakeDamage() then return end
	hp=math.Clamp(hp,0,100)
	net.Start("TARDIS-SetHealth")
		net.WriteEntity(self)
		net.WriteFloat(hp)
	net.Broadcast()
	self.health=hp
	if WireLib then
		Wire_TriggerOutput(self, "Health", math.floor(self.health))
		if self.interior and IsValid(self.interior) then
			self.interior:SetHP(self.health)
		end
	end
	if not self.exploded and hp==0 then
		self:Explode()
	elseif self.exploded and hp>0 then
		self:UnExplode()
	end
end

function ENT:TakeHP(hp)
	if not hp or not self:ShouldTakeDamage() or (self.repairing and not self.repairwait) then return end
	self:SetHP(self.health-hp)
	if self.interior and IsValid(self.interior) then
		sound.Play("Default.ImpactSoft",self.interior:LocalToWorld(Vector(335, 310, 120)))
	end
end

function ENT:AddHP(hp)
	if not hp or not self:ShouldTakeDamage() then return end
	self:SetHP(self.health+hp)
end

function ENT:OnTakeDamage(dmginfo)
	if not self:ShouldTakeDamage() then return end
	local hp=dmginfo:GetDamage()
	self:TakeHP(hp/32) //takes 32th of normal damage a player would take
end

function ENT:SetLight(on)
	if on and not self.exploded and self.visible then
		self.light:Fire("showsprite","",0)
		self.light.on=true
	else
		self.light:Fire("hidesprite","",0)
		self.light.on=false
	end
	net.Start("TARDIS-SetLight")
		net.WriteEntity(self)
		net.WriteBit(self.light.on)
	net.Broadcast()
end

function ENT:ToggleLight()
	if self.light.on then
		self:SetLight(false)
	else
		self:SetLight(true)
	end
end

function ENT:FlashLight(time)
	if not self.visible then return end
	self:SetLight(true)
	timer.Simple(time,function()
		if IsValid(self) and not self.flightmode and not self.moving then
			self:SetLight(false)
		end
	end)
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
		for k,v in pairs(player.GetAll()) do
			if (self:GetPos():Distance(v:GetPos()) < 45) and not (v.tardis and not v.tardis_viewmode) then
				self:PlayerEnter(v)
			end
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
	if not self.moving and vec and not self.repairing then
		self.demat=true
		self.moving=true
		self.vec=vec
		self.attachedents = constraint.GetAllConstrainedEntities(self)
		if self.attachedents then
			for k,v in pairs(self.attachedents) do
				local a=v:GetColor().a
				if not (a==255) then
					v.tempa=a
				end
			end
		end
		if ang then
			self.ang=ang
		end
		if self.exploded then
			local randvec=VectorRand()*1000
			randvec.z=0
			self.vec=self:GetPos()+randvec
			self.ang=self:GetAngles()+AngleRand()
		end
		if self.visible and not self.exploded then
			self:SetLight(true)
		end
		net.Start("TARDIS-Go")
			net.WriteEntity(self)
			net.WriteEntity(self.interior)
			net.WriteBit(tobool(self.exploded))
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
		if not self.flightmode and self.visible then
			self:SetLight(false)
		end
		net.Start("TARDIS-Stop")
			net.WriteEntity(self)
		net.Broadcast()
	end
end

if WireLib then
	function ENT:TriggerInput(k,v)
		if k=="Demat" and v==1 and self.wirepos and self.wireang and not self.moving then
			self:Go(self.wirepos, self.wireang)
		elseif k=="Phase" and v==1 then
			self:TogglePhase()
		elseif k=="Flightmode" and v==1 then
			self:ToggleFlight()
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
	light:SetPos(self:GetPos() + self:GetUp() * 115)
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
		self.exitcur=CurTime()+1
		self:PlayerEnter(ply)
	end
end

function ENT:PlayerEnter( ply )
	if self.occupants then
		for k,v in pairs(self.occupants) do
			if ply==v and (not ply.tardis_viewmode or ply.tardis_skycamera) then return end
		end
	end
	if self.moving then
		return
	end
	if self.locked then
		ply:ChatPrint("This TARDIS is locked.")
		return
	end
	if self.repairing then
		if self.repairfinish then
			ply:ChatPrint("This TARDIS is self-repairing, completion in "..math.floor(self.repairfinish-CurTime()).." seconds.")
		else
			ply:ChatPrint("This TARDIS is self-repairing.")
		end
		return
	end
	if ply.tardis and IsValid(ply.tardis) then
		ply.tardis:PlayerExit( ply )
	end
	ply.tardis=self
	
	net.Start("Player-SetTARDIS")
		net.WriteEntity(ply)
		net.WriteEntity(self)
	net.Broadcast()
	ply.tardis_viewmode=true
	net.Start("TARDIS-SetViewmode")
		net.WriteBit(true)
	net.Send(ply)
	if self.interior and IsValid(self.interior) then
		ply:SetPos(self.interior:LocalToWorld(Vector(300,295,-79)))
		local ang=(ply:EyeAngles()-self:GetAngles())+self.interior:GetAngles()+Angle(0,70,0)
		ply:SetEyeAngles(Angle(ang.p,ang.y,0))
	end
	table.insert(self.occupants,ply)
	if ply:KeyDown(IN_WALK) or (self.interior and not IsValid(self.interior)) then
		self:ToggleViewmode(ply,true)
		self.viewmodecur=CurTime()+1
	end
	net.Start("TARDIS-PlayerEnter") 
		net.WriteEntity(self)
		if self.interior and IsValid(self.interior) then
			net.WriteEntity(self.interior)
		end
	net.Broadcast()
end

function ENT:OnRemove()
	if self.occupants then
		for k,v in pairs(self.occupants) do
			if !v.tardis_viewmode then
				self:ToggleViewmode(v,true)
			end
			self:PlayerExit(v,true)
		end
	end
	self.light:Remove()
	self.light=nil
	if self.interior and IsValid(self.interior) then
		self.interior:Remove()
		self.interior=nil
	end
end

function ENT:PlayerExit( ply, override )
	if self.moving and not override then
		return
	end
	if ply:InVehicle() then ply:ExitVehicle() end
	net.Start("Player-SetTARDIS")
		net.WriteEntity(ply)
		net.WriteEntity(NULL)
	net.Broadcast()
	net.Start("TARDIS-SetViewmode")
		net.WriteBit(false)
	net.Send(ply)
	ply.tardis=nil
	ply.tardis_viewmode=false
	ply.tardisint_pos=nil
	ply.tardisint_ang=nil
	net.Start("TARDIS-SetViewmode")
		net.WriteBit(tobool(ply.tardis_viewmode))
	net.Send(ply)
	ply:SetPos(self:GetPos()+self:GetForward()*55)
	local ang=ply:EyeAngles()+(self:GetPos()-ply:GetPos()):Angle()+Angle(0,110,0)
	ply:SetEyeAngles(Angle(ang.p,ang.y,0))
	if self.occupants then
		for k,v in pairs(self.occupants) do
			if v==ply then
				if override then
					self.occupants[k]=nil
				else
					table.remove(self.occupants,k)
				end
			end
		end
	end
	if ply==self.pilot then // not sure how, but failsafes
		self.pilot=nil
	end
	net.Start("TARDIS-PlayerExit") 
		net.WriteEntity(self)
		if self.interior and IsValid(self.interior) then
			net.WriteEntity(self.interior)
		end
	net.Broadcast()
end

hook.Add("PlayerSpawn", "TARDIS_PlayerSpawn", function( ply )
	local tardis=ply.tardis
	if tardis and IsValid(tardis) then
		if ply.tardis_viewmode and tardis.interior and IsValid(tardis.interior) then
			ply:SetPos(tardis.interior:LocalToWorld(Vector(300,295,-79)))
			local ang=tardis.interior:GetAngles()+Angle(0,-110,0)
			ply:SetEyeAngles(Angle(ang.p,ang.y,0))
		else
			tardis:PlayerExit(ply)
		end
	end
end)

hook.Add("PlayerInitialSpawn", "TARDIS_PlayerInitialSpawn", function( ply )
	timer.Simple(5,function()
		if not IsValid(ply) then return end
		for k,v in pairs(ents.FindByClass("sent_tardis")) do
			if v and IsValid(v) then
				net.Start("TARDIS-UpdateVis")
					net.WriteEntity(v)
					net.WriteBit(tobool(v.visible))
				net.Send(ply)
			end
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
		local rforce=2
		local tilt=0
		
		if self.pilot and IsValid(self.pilot) and not self.pilot.tardis_viewmode and not self.exploded then
			local p=self.pilot
			local eye=p:EyeAngles()
			local fwd=eye:Forward()
			local ri=eye:Right()
			if p:KeyDown(IN_SPEED) then
				force=force*2.5
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
				if p:KeyDown(IN_WALK) then
					ph:AddAngleVelocity(Vector(0,0,-rforce))
				else
					ph:AddVelocity(ri*force*phm)
					tilt=tilt+5
				end
			end
			if p:KeyDown(IN_MOVELEFT) then
				if p:KeyDown(IN_WALK) then
					ph:AddAngleVelocity(Vector(0,0,rforce))
				else
					ph:AddVelocity(-ri*force*phm)
					ilt=tilt+5
				end
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
			local angbrake=ph:GetAngleVelocity()*-0.015
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
			if not v.tardis_viewmode then
				v:SetPos(pos)
			end
		end
	end
end

function ENT:PhysicsCollide( data, physobj )
	if data.Speed and data.Speed>200 then
		local n=math.Clamp(data.Speed*0.01,0,16)
		self:TakeHP(n*0.1) // approximately 1hp for a moderate hit
		if self.interior and IsValid(self.interior) then
			util.ScreenShake(self.interior:GetPos(),n,5,0.5,700)
		end
	end
end

function ENT:ToggleFlight()
	if not (CurTime()>self.flightcur) then return false end
	if self.repairing then return false end
	local flightphase=tobool(GetConVarNumber("tardis_flightphase"))==true
	if not flightphase and not self.visible then return false end
	self.flightcur=CurTime()+1
	self.flightmode=(not self.flightmode)
	if self.flightmode then
		if !self.RotorWash and self.visible then
			self:CreateRotorWash()
		end		
	else
		if self.RotorWash and not self.moving and self.visible then
			self.RotorWash:Remove()
			self.RotorWash = nil
		end
	end
	if self.phys and IsValid(self.phys) then
		self.phys:EnableGravity(not self.flightmode)
	end
	if self.visible and not self.moving and not self.exploded then
		self:SetLight(self.flightmode)
	end
	net.Start("TARDIS-Flightmode")
		net.WriteEntity(self)
		net.WriteBit(tobool(self.flightmode))
	net.Broadcast()
	return true
end

function ENT:CreateRotorWash()
	if IsValid(self.RotorWash) then return end
	self.RotorWash = ents.Create("env_rotorwash_emitter")
	self.RotorWash:SetPos(self:GetPos())
	self.RotorWash:SetParent(self)
	self.RotorWash:Activate()
end

function ENT:TogglePhase()
	local flightphase=tobool(GetConVarNumber("tardis_flightphase"))==true
	if CurTime()>self.phasecur and not self.exploded and not self.repairing then
		if self.flightmode and not flightphase then return false end
		self.phasecur=CurTime()+2
		self.visible=(not self.visible)
		net.Start("TARDIS-Phase")
			net.WriteEntity(self)
			net.WriteBit(tobool(self.visible))
		net.Broadcast()
		self:DrawShadow(self.visible)
		if self.visible and (self.moving or self.flightmode) then
			self:SetLight(true)
		else
			self:SetLight(false)
		end
		if self.RotorWash and not self.visible then
			self.RotorWash:Remove()
			self.RotorWash = nil
		elseif !self.RotorWash and self.visible then
			self:CreateRotorWash()
		end
		return true
	end
	return false
end

function ENT:ToggleViewmode(ply,deldata)
	ply.tardis_viewmode=(not ply.tardis_viewmode) // true = inside, false = third-person view
	net.Start("TARDIS-SetViewmode")
		net.WriteBit(tobool(ply.tardis_viewmode))
	net.Send(ply)
	if ply.tardis_viewmode then
		ply:UnSpectate()
		ply:DrawViewModel(true)
		ply:DrawWorldModel(true)
		ply:Spawn()
		if ply.weps then
			for k,v in pairs(ply.weps) do
				ply:Give(tostring(v))
			end
		end
		if self.pilot and IsValid(self.pilot) and self.pilot==ply then
			self.pilot=nil
			local tbl={}
			for k,v in pairs(self.occupants) do
				if not v.tardis_viewmode then
					table.insert(tbl,v)
				end
			end
			if #tbl>0 then
				local newpilot=tbl[math.random(#tbl)]
				if newpilot and IsValid(newpilot) and newpilot:IsPlayer() then
					self.pilot=newpilot
					self.pilot:ChatPrint("You are now the pilot.")
					for k,v in pairs(tbl) do
						if not (v==self.pilot) then
							v:ChatPrint(self.pilot:Nick().." is now the pilot.")
						end
					end
				end
				ply:ChatPrint(self.pilot:Nick().." is now the pilot.")
			else
				ply:ChatPrint("You are no longer the pilot.")
			end
		end
		if self.interior and IsValid(self.interior) then
			if not deldata and ply.tardisint_pos and ply.tardisint_ang then
				ply:SetPos(self.interior:LocalToWorld(ply.tardisint_pos))
				ply:SetEyeAngles(ply.tardisint_ang)
				ply.tardisint_pos=nil
				ply.tardisint_ang=nil
			else
				ply:SetPos(self.interior:GetPos()+Vector(300,295,-79))
				local ang=self.interior:GetAngles()+Angle(0,-110,0)
				ply:SetEyeAngles(Angle(ang.p,ang.y,0))
			end
		end
	else
		if not deldata then
			ply.tardisint_pos=self.interior:WorldToLocal(ply:GetPos())
			ply.tardisint_ang=ply:EyeAngles()
		end
		ply.weps={}
		for k,v in pairs(ply:GetWeapons()) do
			table.insert(ply.weps, v:GetClass())
		end
		ply:Spectate( OBS_MODE_ROAMING )
		ply:DrawViewModel(false)
		ply:DrawWorldModel(false)
		ply:CrosshairDisable(true)
		ply:StripWeapons()
		if self.pilot then
			ply:ChatPrint(self.pilot:Nick().." is the pilot.")
		else
			self.pilot=ply
			self.pilot:ChatPrint("You are now the pilot.")
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
	
	if self.pilot and not IsValid(self.pilot) then
		self.pilot=nil
	end
	
	if self.repairing and not self.repairwait and self.repairfinish and CurTime()>self.repairfinish then
		self:EndRepair(true)
	end

	if self.occupants then
		if self.repairwait and #self.occupants==0 then
			self:BeginRepair()
		end
		for k,v in pairs(self.occupants) do
			if not IsValid(v) then
				self.occupants[k]=nil
				continue
			end
			if CurTime()>self.viewmodecur and v:KeyDown(IN_USE) and not v.tardis_viewmode then
				self:ToggleViewmode(v)
				self.viewmodecur=CurTime()+1
				if v:KeyDown(IN_WALK) or (self.interior and not IsValid(self.interior)) then
					self:PlayerExit(v)
					self.exitcur=CurTime()+1
				end
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
		if !self.RotorWash and self.visible then
			self:CreateRotorWash()
		end
	else
		if self.RotorWash and not self.flightmode and self.visible then
			self.RotorWash:Remove()
			self.RotorWash = nil
		end
	end
	
	if self.phys and IsValid(self.phys) then
		self.phys:Wake()
	end
	
	if CurTime() > self.flightcur and self.pilot and IsValid(self.pilot) and self.pilot:KeyDown(IN_RELOAD) and not self.pilot.tardis_viewmode then
		self:ToggleFlight()
	end
	
	if CurTime() > self.phasecur and self.pilot and IsValid(self.pilot) and self.pilot:KeyDown(IN_ATTACK2) and not self.pilot.tardis_viewmode then
		self:TogglePhase()
	end
	
	if not self.moving and not self.repairing and self.pilot and IsValid(self.pilot) and self.pilot:KeyDown(IN_ATTACK) and not self.pilot.tardis_viewmode then
		if self.pilot.linked_tardis and self.pilot.linked_tardis==self and self.pilot.tardis_vec and self.pilot.tardis_ang then
			self:Go(self.pilot.tardis_vec, self.pilot.tardis_ang)
			self.pilot.tardis_vec=nil
			self.pilot.tardis_ang=nil
			self.pilot:ChatPrint("TARDIS moving to set destination.")
		else
			local filter=table.Copy(self.occupants)
			table.insert(filter,self)
			local trace = util.QuickTrace( self.pilot:EyePos(), self.pilot:GetAimVector() * 9999999, filter)
			local angle = Angle(0,self.pilot:GetAngles().y+180,0)
			self:Go(trace.HitPos, angle)
			self.pilot:ChatPrint("TARDIS moving to AimPos.")
		end
	end
	
	// this bit makes it all run faster and smoother
    self:NextThink( CurTime() )
	return true
end