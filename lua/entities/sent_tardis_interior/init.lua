AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDIS-SetViewmode")
 
function ENT:Initialize()
	self:SetModel( "models/The_Sniper_9/DoctorWho/Tardis/tardisinteriorsmith.mdl" )
	// cheers to doctor who team for the model
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
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
end

function ENT:Explode()
	self.exploded=true
	self.fire = ents.Create("env_fire_trail")
	self.fire:SetPos(self:LocalToWorld(Vector(335, 310, 200)))
	self.fire:Spawn()
	self.fire:SetParent(self)
	
	local explode = ents.Create("env_explosion")
	explode:SetPos(self:LocalToWorld(Vector(-25,-3,220)))
	explode:Spawn()
	explode:Fire("Explode",0)
end

function ENT:OnRemove()
	if self.fire then
		self.fire:Remove()
		self.fire=nil
	end
	if self.cloisterbell then
		self.cloisterbell:Stop()
		self.cloisterbell=nil
	end
end

function ENT:Use( ply )
	if self.tardis and IsValid(self.tardis) and ply.tardis and IsValid(ply.tardis) and ply.tardis==self.tardis and ply.tardis_viewmode then
		if CurTime()>self.tardis.exitcur then
			local pos=Vector(335, 310, 120)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 25 then
				self.tardis:PlayerExit(ply,true)
				self.tardis.exitcur=CurTime()+1
			end
		end
		
		if CurTime()>self.tardis.viewmodecur then
			local pos=Vector(-28,-3,210)
			local pos2=self:WorldToLocal(ply:GetPos())
			local distance=pos:Distance(pos2)
			if distance < 100 then
				self.tardis:ToggleViewmode(ply)
				self.tardis.viewmodecur=CurTime()+1
			end
		end
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
		if self.tardis.exploded and not self.exploded then
			self:Explode()
		end
		if self.tardis.health <= 20 then
			if self.cloisterbell and not self.cloisterbell:IsPlaying() then
				self.cloisterbell:Play()
			elseif not self.cloisterbell then
				self.cloisterbell = CreateSound(self, "tardis/cloisterbell_loop.wav")
				self.cloisterbell:Play()
			end
		end
	end
end