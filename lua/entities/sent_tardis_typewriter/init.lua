AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("TARDISInt-Locations-GUI")
util.AddNetworkString("TARDISInt-Locations-Send")

function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/typewriter.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetColor(Color(255,255,255,255))
	self.phys = self:GetPhysicsObject()
	self:SetNWEntity("TARDIS",self.tardis)
	self.usecur=0
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
end

function ENT:Use( activator, caller, type, value )

	if ( !activator:IsPlayer() ) then return end		-- Who the frig is pressing this shit!?
	if IsValid(self.tardis) and self.tardis.isomorphic and not (activator==self.owner) then
		return
	end
	
	local interior=self.interior
	local tardis=self.tardis
	if IsValid(interior) and IsValid(self.tardis) then
		interior.usecur=CurTime()+1
		if CurTime()>self.usecur then
			self.usecur=CurTime()+1
			if self.advanced then
				interior:UpdateAdv(activator,false)
			end
			net.Start("TARDISInt-Locations-GUI")
				net.WriteEntity(self.interior)
				net.WriteEntity(self.tardis)
			net.Send(activator)
		end
	end
	
	self:NextThink( CurTime() )
	return true
end

net.Receive("TARDISInt-Locations-Send", function(l,ply)
	local interior=net.ReadEntity()
	local tardis=net.ReadEntity()
	if IsValid(interior) and IsValid(tardis) then
		local pos=Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		local ang=Angle(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		if interior.advanced then
			if interior.flightmode==0 and interior.step==0 then
				interior:StartAdv(2,ply,pos,ang)
				ply:ChatPrint("Programmable flightmode activated.")
			else
				interior:UpdateAdv(ply,false)
			end
		else
			if not tardis.moving then
				tardis:Go(pos,ang)
			end
		end
	end
end)