AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel( "models/tardis.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	//self:StartMotionController() -- what the hell, this is being stupid
	
	self.light = self:SpawnLight()
	self:SetLight(false)
	self.a=255 // alpha
	self.cur=0
	self.curdelay=0.01
	self.cycle=1
	self.step=1
	self.exitcur=0
	self.pilotcur=0
	self.Pilot = nil
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

function ENT:SetLight(on)
	if on then
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
	if not self.moving and vec then
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
		sound.Play("tardis/demat.wav", self:GetPos(), 100)
		sound.Play("tardis/mat.wav", self.vec, 100)
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
		self:SetLight(false)
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
		self.exitcur=CurTime()+1
		ply:SetNWEntity("TARDIS", self)
		ply:SetNWBool("InTARDIS", true)
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
			self.Pilot=ply
		end
	end
end

function ENT:OnRemove()
	for k,v in pairs(player.GetAll()) do
		local tardis=v:GetNWEntity("TARDIS")
		if tardis and IsValid(tardis) and tardis==self then
			self:PlayerExit(v,true)
		end
	end
	self.light:Remove()
	self.light=nil
end

function ENT:PlayerExit( ply, override )
	if (CurTime() > self.exitcur) or override then
		self.exitcur=CurTime()+1
		ply:UnSpectate()
		ply:DrawViewModel(true)
		ply:DrawWorldModel(true)
		ply:Spawn()
		ply:SetNWEntity("TARDIS", nil)
		ply:SetNWBool("InTARDIS", false)
		ply:CrosshairDisable(false)
		ply:CrosshairEnable(true)
		if ply.weps then
			for k,v in pairs(ply.weps) do
				ply:Give(tostring(v))
			end
		end
		ply:SetPos(self:GetPos()+self:GetForward()*75)
		ply:SetEyeAngles((self:GetPos()-ply:GetPos()):Angle()) // make you face the tardis
		self.occupants[ply]=nil
		if self.Pilot and self.Pilot==ply then
			self.Pilot=nil
		end
	end
end

function ENT:UpdateAlpha()
	// utility functions!
	local maincol=self:GetColor()
	maincol=Color(maincol.r,maincol.g,maincol.b,self.a)
	self:SetColor(maincol)
	if self.attachedents then
		for k,v in pairs(self.attachedents) do
			local col=v:GetColor()
			col=Color(col.r,col.g,col.b,self.a)
			if IsValid(v) and not (v.tempa==0) then
				if not (v:GetRenderMode()==RENDERMODE_TRANSALPHA) then
					v:SetRenderMode(RENDERMODE_TRANSALPHA)
				end
				v:SetColor(col)
			end
		end
	end
end

function ENT:Think()
	for k,v in pairs(player.GetAll()) do
		local tardis=v:GetNWEntity("TARDIS")
		if v:KeyDown(IN_USE) and tardis and IsValid(tardis) and tardis==self then
			self:PlayerExit(v)
		end
	end
	
	/* hopefully i'll get this working one day - stupid weird bugs
	if self.Pilot and IsValid(self.Pilot) and self.Pilot:KeyDown(IN_RELOAD) and CurTime()>self.pilotcur then
		self.pilotcur=CurTime()+1
		self.Flying=(not self.Flying)
		if self.Flying then
			self.Pilot:ChatPrint("TARDIS now flying.")
		else
			self.Pilot:ChatPrint("TARDIS no longer flying.")
		end
	end
	*/

	if CurTime() > self.cur then
		if self.demat then
			self:Dematerialize()
		elseif self.mat then
			self:Materialize()
		end
		self.cur=CurTime()+self.curdelay
	end
	
	// this bit makes it all run faster and smoother
    self:NextThink( CurTime() )
	return true
end