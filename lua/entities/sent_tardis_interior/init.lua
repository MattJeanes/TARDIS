AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDIS-SetViewmode")
util.AddNetworkString("TARDISInt-SetParts")

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
	
	self.skycamera=self:MakePart("sent_tardis_skycamera", Vector(0,0,-350+GetConVarNumber("tardis_spawnoffset")), Angle(90,0,0),false)
	self.throttle=self:MakePart("sent_tardis_throttle", Vector(-8.87,-50,5.5), Angle(-12,-5,24),true)
	self.atomaccel=self:MakePart("sent_tardis_atomaccel", Vector(20,-37.67,1.75), Angle(0,0,0),true)
	self.screen=self:MakePart("sent_tardis_screen", Vector(42,0.75,27.1), Angle(0,-5,0),true)
	self.repairlever=self:MakePart("sent_tardis_repairlever", Vector(44,-18,5.5), Angle(22,-32,-12.5),true)
	self.wibblylever=self:MakePart("sent_tardis_wibblylever", Vector(-48,18,5.4), Angle(-25,-13,6),true)
	
	net.Start("TARDISInt-SetParts")
		net.WriteFloat(#self.parts)
		for k,v in pairs(self.parts) do
			net.WriteEntity(v)
		end
	net.Broadcast()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:MakePart(class,vec,ang,weld)
	local ent=ents.Create(class)
	ent.tardis=self.tardis
	ent.interior=self
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