AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDIS-SetViewmode")

function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/interior.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
	
	if self.tardis then
		self:SetNWEntity("TARDIS",self.tardis)
	end
	
	self.viewcur=0
	self.timerotor_pos=0
	
	if WireLib then
		Wire_CreateInputs(self, { "Demat", "Phase", "Flightmode", "X", "Y", "Z", "XYZ [VECTOR]", "Rot" })
		Wire_CreateOutputs(self, { "Health" })
	end
	
	// this is a biiiiit hacky, but it works!
	local vname="Seat_Airboat"
	local chair=list.Get("Vehicles")[vname]
	self.chair1=self:MakeVehicle(self:LocalToWorld(Vector(130,-96,-30)), Angle(0,40,0), chair.Model, chair.Class, vname, chair)
	self.chair2=self:MakeVehicle(self:LocalToWorld(Vector(125,55,-30)), Angle(0,135,0), chair.Model, chair.Class, vname, chair)
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
	
	ent.tardis_chair=true
	ent:GetPhysicsObject():EnableMotion(false)
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetColor(Color(255,255,255,0))
	constraint.Weld(self,ent,0,0)

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
	if self.chair1 then
		self.chair1:Remove()
		self.chair1=nil
	end
	if self.chair2 then
		self.chair2:Remove()
		self.chair2=nil
	end
end

function ENT:Use( ply )
	if self.tardis and IsValid(self.tardis) and ply.tardis and IsValid(ply.tardis) and ply.tardis==self.tardis and ply.tardis_viewmode then
		if CurTime()>self.tardis.exitcur then
			local pos=Vector(300,295,-79)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 25 then
				self.tardis:PlayerExit(ply,true)
				self.tardis.exitcur=CurTime()+1
			end
		end
		
		if CurTime()>self.tardis.viewmodecur then
			local pos=Vector(0,0,0)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 110 then
				self.tardis:ToggleViewmode(ply)
				self.tardis.viewmodecur=CurTime()+1
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
				if self:GetPos():Distance(v:GetPos()) > 700 and v.tardis_viewmode then
					self.tardis:PlayerExit(v,true)
				end
			end
		end
		
		if (self.timerotor_pos>0 and not self.tardis.moving or self.tardis.flightmode) or (self.tardis.moving or self.tardis.flightmode) then
			if self.timerotor_pos==1 then
				self.timerotor_mode=false
			elseif self.timerotor_pos==0 and (self.tardis.moving or self.tardis.flightmode) then
				self.timerotor_mode=true
			end
			
			self.timerotor_pos=math.Approach( self.timerotor_pos, self.timerotor_mode and 1 or 0, FrameTime()*1.1 )
			self:SetPoseParameter( "glass", self.timerotor_pos )
		end
	end
	
	self:NextThink( CurTime() )
	return true
end