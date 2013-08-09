AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDISInt-SetSkyCamera")

function ENT:Initialize()
	self:SetModel( "models/props_junk/PopCan01a.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor(Color(255,255,255,0))
	self.phys = self:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
	
	self:SetNWEntity("TARDIS",self.tardis)
	
	self.usecur=0
	self.setcur=0
	self.resetcur=0
	
	self.occupants={}
end

/*
function ENT:Use( ply )
	if CurTime()>self.usecur then
		self.usecur=CurTime()+1
		self:PlayerEnter(ply)
	end
end
*/

function ENT:PlayerEnter(ply)
	for k,v in pairs(self.occupants) do
		if ply==v then
			return
		end
	end
	net.Start("TARDISInt-SetSkyCamera")
		net.WriteEntity(self)
	net.Send(ply)
	if self.interior and IsValid(self.interior) then
		ply.tardisint_pos=self.interior:WorldToLocal(ply:GetPos())
		ply.tardisint_ang=ply:EyeAngles()
	end
	ply.weps={}
	for k,v in pairs(ply:GetWeapons()) do
		table.insert(ply.weps, v:GetClass())
	end
	ply.tardis_skycamera=self
	ply:Spectate( OBS_MODE_ROAMING )
	ply:DrawViewModel(false)
	ply:DrawWorldModel(false)
	ply:CrosshairDisable(true)
	ply:StripWeapons()
	ply.oldfov=ply:GetFOV()
	ply:SetViewEntity(self)
	table.insert(self.occupants,ply)
	if self.controller then
		ply:ChatPrint(self.controller:Nick().." is the camera controller.")
	else
		self.controller=ply
		ply:ChatPrint("You are now the camera controller.")
	end
end

function ENT:PlayerExit(ply,override)
	for k,v in pairs(self.occupants) do
		if v==ply then
			if override then
				self.occupants[k]=nil
			else
				table.remove(self.occupants,k)
			end
		end
	end
	net.Start("TARDISInt-SetSkyCamera")
		net.WriteEntity(NULL)
	net.Send(ply)
	ply.tardis_skycamera=nil
	ply:UnSpectate()
	ply:DrawViewModel(true)
	ply:DrawWorldModel(true)
	ply:Spawn()
	if ply.weps then
		for k,v in pairs(ply.weps) do
			ply:Give(tostring(v))
		end
	end
	if ply.tardisint_pos and ply.tardisint_ang then
		ply:SetPos(self.interior:LocalToWorld(ply.tardisint_pos))
		ply:SetEyeAngles(ply.tardisint_ang)
		ply.tardisint_pos=nil
		ply.tardisint_ang=nil
	end
	if ply.oldfov then
		ply:SetFOV(ply.oldfov,0)
		ply.oldfov=nil
	end
	ply:SetViewEntity(nil)
	if self.controller and self.controller==ply then
		self.controller=nil
		if #self.occupants>0 then
			local newcontroller=self.occupants[math.random(#self.occupants)]
			if newcontroller and IsValid(newcontroller) and newcontroller:IsPlayer() then
				self.controller=newcontroller
				self.controller:ChatPrint("You are now the camera controller.")
				for k,v in pairs(self.occupants) do
					if not (v==self.controller) then
						v:ChatPrint(self.controller:Nick().." is now the camera controller.")
					end
				end
			end
			ply:ChatPrint(self.controller:Nick().." is now the camera controller.")
		end
	end
end

function ENT:MoveLocal(vec,force)
	self:SetPos(self:LocalToWorld(vec*force))
	//local trace=util.QuickTrace(self:GetPos(),self:GetForward()*9999999, self)
	//self.hitpos=trace.HitPos
end

function ENT:RotateLocal(rot)
	self:SetAngles(self:GetAngles()+Angle(0,rot,0))
end

function ENT:OnRemove()
	if self.controller and IsValid(self.controller) and self.controller:IsPlayer() then
		self:PlayerExit(self.controller)
	end
	for k,v in pairs(self.occupants) do
		self:PlayerExit(v,true)
	end
end

function ENT:Think()
	if self.controller and IsValid(self.controller) and self.controller:IsPlayer() then		
		local force=30
		if self.controller:KeyDown(IN_SPEED) then
			force=60
		end
		
		if self.controller:KeyDown(IN_ATTACK2) then
			if self.controller:KeyDown(IN_SPEED) then
				force=30
			else
				force=15
			end
		end
		
		local vec=Vector(0,0,0)
		if self.controller:KeyDown(IN_FORWARD) then
			vec=vec+Vector(0,0,1)
		elseif self.controller:KeyDown(IN_BACK) then
			vec=vec+Vector(0,0,-1)
		end
		
		if self.controller:KeyDown(IN_MOVELEFT) then
			if self.controller:KeyDown(IN_WALK) then
				self:RotateLocal(2)
			else
				vec=vec+Vector(0,1,0)
			end
		elseif self.controller:KeyDown(IN_MOVERIGHT) then
			if self.controller:KeyDown(IN_WALK) then
				self:RotateLocal(-2)
			else
				vec=vec+Vector(0,-1,0)
			end
		end
		
		if not (vec==Vector(0,0,0)) then
			self:MoveLocal(vec,force)
		end
		
		if self.controller:KeyDown(IN_ATTACK) then
			if CurTime()>self.setcur then
				self.setcur=CurTime()+1
				local trace=util.QuickTrace(self:GetPos(),self:GetForward()*9999999, self)
				self.hitpos=trace.HitPos
				local ang=self:GetAngles()
				self.hitang=Angle(0,ang.y,0)
				self.controller:ChatPrint("TARDIS destination set.")
			end
		end
		
		if self.controller:KeyDown(IN_RELOAD) then
			if CurTime()>self.resetcur and self.interior and IsValid(self.interior) then
				self.resetcur=CurTime()+1
				self:SetPos(self.interior:GetPos()+Vector(0,0,-350))
				self:SetAngles(Angle(90,0,0))
				self.controller:ChatPrint("TARDIS camera reset.")
			end
		end
	end
	
	for k,v in pairs(self.occupants) do
		if CurTime()>self.usecur and v:KeyDown(IN_USE) then
			self.usecur=CurTime()+1
			self:PlayerExit(v)
			return
		end
		if v:KeyDown(IN_ATTACK2) then
			v:SetFOV(30,0)
		elseif not (v:GetFOV()==90) then
			v:SetFOV(90,0)
		end
	end
	
	if self.tardis and IsValid(self.tardis) then
		for k,v in pairs(self.occupants) do
			v:SetPos(self.tardis:GetPos())
		end
	end
	
	self:NextThink(CurTime())
	return true
end