AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDIS-SetViewmode")
util.AddNetworkString("TARDISInt-SetParts")
util.AddNetworkString("TARDISInt-UpdateAdv")
util.AddNetworkString("TARDISInt-SetAdv")

function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/interior.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:DrawShadow(false)
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
	
	self:SetNWEntity("TARDIS",self.tardis)
	
	self.viewcur=0
	self.throttlecur=0
	self.usecur=0
	self.flightmode=0 //0 is none, 1 is skycamera selection, 2 is idk yet or whatever and so on
	self.step=0
	
	
	if WireLib then
		Wire_CreateInputs(self, { "Demat", "Phase", "Flightmode", "X", "Y", "Z", "XYZ [VECTOR]", "Rot" })
		Wire_CreateOutputs(self, { "Health" })
	end
	
	self.parts={}
	
	// this is a biiiiit hacky, but it works!
	local vname="Seat_Airboat"
	local chair=list.Get("Vehicles")[vname]
	self.chair1=self:MakeVehicle(self:LocalToWorld(Vector(130,-96,-30)), Angle(0,40,0), chair.Model, chair.Class, vname, chair)
	self.chair2=self:MakeVehicle(self:LocalToWorld(Vector(125,55,-30)), Angle(0,135,0), chair.Model, chair.Class, vname, chair)
	
	self.skycamera=self:MakePart("sent_tardis_skycamera", Vector(0,0,-350), Angle(90,0,0),false)
	self.throttle=self:MakePart("sent_tardis_throttle", Vector(-8.87,-50,5.5), Angle(-12,-5,24),true)
	self.atomaccel=self:MakePart("sent_tardis_atomaccel", Vector(20,-37.67,1.75), Angle(0,0,0),true)
	self.screen=self:MakePart("sent_tardis_screen", Vector(42,0.75,27.1), Angle(0,-5,0),true)
	self.repairlever=self:MakePart("sent_tardis_repairlever", Vector(-6.623535, 44.351563, 7), Angle(-11, 5, -23),true)
	self.wibblylever=self:MakePart("sent_tardis_wibblylever", Vector(-48,18,5.4), Angle(-25,-13,6),true)
	self.directionalpointer=self:MakePart("sent_tardis_directionalpointer", Vector(12.5,-24.5,23), Angle(0,30,0),true)
	self.keyboard=self:MakePart("sent_tardis_keyboard", Vector(29,-53,-8), Angle(0,30,50),true)
	self.helmicregulator=self:MakePart("sent_tardis_helmicregulator", Vector(-26,-41,4), Angle(0,-30,24.5),true)
	self.handbrake=self:MakePart("sent_tardis_handbrake", Vector(-40.088379, -21.466797, 7.924805), Angle(-69.506, -151.679, -177.843),true)
	self.biglever=self:MakePart("sent_tardis_biglever", Vector(-9.94,-65,-52), Angle(0,-90,0),true)
	self.blacksticks=self:MakePart("sent_tardis_blacksticks", Vector(4.480469, -43.906372, 7), Angle(13, 0, 24.176),true)
	self.typewriter=self:MakePart("sent_tardis_typewriter", Vector(19.002930, 48.807617, 2.078125), Angle(0.945, -29.872, -20.250),true)
	self.flightlever=self:MakePart("sent_tardis_flightlever", Vector(44,-18,5.5), Angle(22,-32,-12.5),true)
	self.physbrake=self:MakePart("sent_tardis_physbrake", Vector(39, -22.75, 6.914063), Angle(-56.714, 6.660, 148.819),true)
	
	self.unused1=self:MakePart("sent_tardis_unused", Vector(-39.5, 22, 6.629883), Angle(-69.238, -165, 137.777),true)
	self.unused2=self:MakePart("sent_tardis_unused", Vector(-0.431641, 44.75, 6.4), Angle(-63.913, 137.035, 136.118),true)
	self.unused3=self:MakePart("sent_tardis_unused", Vector(39, 22.75, 5.828125), Angle(-63.740, 78.027, 136.528),true)
	self.unused4=self:MakePart("sent_tardis_unused", Vector(-2.5, -45.5, 7.75), Angle(-56.714, -54.280, 148.819),true)
	
	net.Start("TARDISInt-SetParts")
		net.WriteFloat(#self.parts)
		for k,v in pairs(self.parts) do
			net.WriteEntity(v)
		end
	net.Broadcast()
end

function ENT:StartAdv(mode,ply,pos,ang)
	if self.flightmode==0 and self.step==0 then
		self.flightmode=mode
		self.step=1
		if pos and ang then
			self.advpos=pos
			self.advang=ang
		end
		net.Start("TARDISInt-SetAdv")
			net.WriteEntity(self)
			net.WriteEntity(ply)
			net.WriteFloat(mode)
		net.Send(ply)
	end
end

function ENT:UpdateAdv(ply,success)
	if not (self.flightmode==0) then
		if success then
			self.step=self.step+1
			if self.flightmode==1 and self.step==5 then
				local skycamera=self.skycamera
				if IsValid(self.tardis) and not self.tardis.moving and IsValid(skycamera) and skycamera.hitpos and skycamera.hitang then
					self.tardis:Go(skycamera.hitpos, skycamera.hitang)
					skycamera.hitpos=nil
					skycamera.hitang=nil
				else
					ply:ChatPrint("Error, already teleporting or no coordinates set.")
				end
				self.flightmode=0
				self.step=0
			elseif self.flightmode==2 and self.step==5 then
				if IsValid(self.tardis) and not self.tardis.moving and self.advpos and self.advpos then
					self.tardis:Go(self.advpos, self.advang)
				else
					ply:ChatPrint("Error, already teleporting or no coordinates set.")
				end
				self.advpos=nil
				self.advang=nil
				self.flightmode=0
				self.step=0
			end
		else
			//ply:ChatPrint("Failed.")
			self.flightmode=0
			self.step=0
			self.advpos=nil
			self.advang=nil
		end
		net.Start("TARDISInt-UpdateAdv")
			net.WriteBit(success)
		net.Send(ply)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:MakePart(class,vec,ang,weld)
	local ent=ents.Create(class)
	ent.tardis=self.tardis
	ent.interior=self
	ent.advanced=self.advanced
	ent:SetPos(self:LocalToWorld(vec))
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	if weld then
		constraint.Weld(self,ent,0,0)
	end
	table.insert(self.parts,ent)
	return ent
end

function ENT:MakeVehicle( Pos, Ang, Model, Class, VName, VTable ) // for the chairs
	local ent = ents.Create( Class )
	if (!ent) then return NULL end
	
	ent:SetModel( Model )
	
	-- Fill in the keyvalues if we have them
	if ( VTable && VTable.KeyValues ) then
		for k, v in pairs( VTable.KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end
		
	ent:SetAngles( Ang )
	ent:SetPos( Pos )
		
	ent:Spawn()
	ent:Activate()
	
	ent.VehicleName 	= VName
	ent.VehicleTable 	= VTable
	
	-- We need to override the class in the case of the Jeep, because it 
	-- actually uses a different class than is reported by GetClass
	ent.ClassOverride 	= Class
	
	ent.tardis_part=true
	ent:GetPhysicsObject():EnableMotion(false)
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetColor(Color(255,255,255,0))
	constraint.Weld(self,ent,0,0)
	
	table.insert(self.parts,ent)

	return ent
end

if WireLib then
	function ENT:TriggerInput(k,v)
		if self.tardis and IsValid(self.tardis) then
			self.tardis:TriggerInput(k,v)
		end
	end
end

function ENT:SetHP(hp)
	if WireLib then
		Wire_TriggerOutput(self, "Health", math.floor(hp))
	end
end

function ENT:Explode()
	self.exploded=true
	
	self.fire = ents.Create("env_fire_trail")
	self.fire:SetPos(self:LocalToWorld(Vector(0,0,0)))
	self.fire:Spawn()
	self.fire:SetParent(self)
	
	local explode = ents.Create("env_explosion")
	explode:SetPos(self:LocalToWorld(Vector(0,0,50)))
	explode:Spawn()
	explode:Fire("Explode",0)
	
	self:SetColor(Color(255,233,200))
end

function ENT:UnExplode()
	self.exploded=false
	
	if self.fire and IsValid(self.fire) then
		self.fire:Remove()
		self.fire=nil
	end
	
	self:SetColor(Color(255,255,255))
end

function ENT:OnRemove()
	if self.fire then
		self.fire:Remove()
		self.fire=nil
	end
	for k,v in pairs(self.parts) do
		if IsValid(v) then
			v:Remove()
			v=nil
		end
	end
end

function ENT:PlayerLookingAt(ply,vec,fov,Width)	
	local Disp = vec - self:WorldToLocal(ply:GetPos()+Vector(0,0,64))
	local Dist = Disp:Length()
	
	local MaxCos = math.abs( math.cos( math.acos( Dist / math.sqrt( Dist * Dist + Width * Width ) ) + fov * ( math.pi / 180 ) ) )
	Disp:Normalize()
	
	if Disp:Dot( ply:EyeAngles():Forward() ) > MaxCos then
		return true
	end
	
    return false
end

function ENT:Use( ply )
	if CurTime()>self.usecur and self.tardis and IsValid(self.tardis) and ply.tardis and IsValid(ply.tardis) and ply.tardis==self.tardis and ply.tardis_viewmode and not ply.tardis_skycamera then
		self.usecur=CurTime()+1
		
		if CurTime()>self.tardis.exitcur then
			local pos=Vector(300,295,-79)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 25 then
				self.tardis:PlayerExit(ply)
				self.tardis.exitcur=CurTime()+1
				return
			end
		end

		//this must go last, or bad things will happen
		if CurTime()>self.tardis.viewmodecur then
			local pos=Vector(0,0,0)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 110 and self:PlayerLookingAt(ply, Vector(0,0,0), 25, 25) then
				self.tardis:ToggleViewmode(ply)
				self.tardis.viewmodecur=CurTime()+1
				return
			end
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self.tardis and IsValid(self.tardis) then
		self.tardis:OnTakeDamage(dmginfo)
	end
end

function ENT:Think()
	if self.tardis and IsValid(self.tardis) then
		if self.tardis.occupants then
			for k,v in pairs(self.tardis.occupants) do
				if self:GetPos():Distance(v:GetPos()) > 700 and v.tardis_viewmode and not v.tardis_skycamera then
					self.tardis:PlayerExit(v,true)
				end
			end
		end
	end
end