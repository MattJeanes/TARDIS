AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/drmatt/tardis/throttle.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetUseType( ONOFF_USE )
	self:SetColor(Color(255,255,255,255))
	self.phys = self:GetPhysicsObject()
	self:SetNWEntity("TARDIS",self.tardis)
	if (self.phys:IsValid()) then
		self.phys:EnableMotion(false)
	end
end

function ENT:SetLabel( text )

	text = string.gsub( text, "\\", "" )
	text = string.sub( text, 0, 20 )
	
	if ( text != "" ) then
	
		text = "\""..text.."\""
	
	end
	
	self:SetOverlayText( text )
	
end

function ENT:Use( activator, caller, type, value )

	if ( !activator:IsPlayer() ) then return end		-- Who the frig is pressing this shit!?
	if IsValid(self.tardis) and self.tardis.isomorphic and not (activator==self.owner) then
		return
	end
	
	if ( self:GetIsToggle() ) then

		if ( type == USE_ON ) then
			self:Toggle( !self:GetOn(), activator )
		end
		return;

	end

	if ( IsValid( self.LastUser ) ) then return end		-- Someone is already using this button

	--
	-- Switch off
	--
	if ( self:GetOn() ) then 
	
		self:Toggle( false, activator )
		
	return end

	--
	-- Switch on
	--
	self:Toggle( true, activator )
	self:NextThink( CurTime() )
	self.LastUser = activator
	
end

function ENT:Think()
	if ( self:GetOn() && !self:GetIsToggle() ) then 
	
		if ( !IsValid( self.LastUser ) || !self.LastUser:KeyDown( IN_USE ) ) then
			
			self:Toggle( false, self.LastUser )
			self.LastUser = nil
			
		end	

		self:NextThink( CurTime() )
		return true
	
	end
end

--
-- Makes the button trigger the keys
--
function ENT:Toggle( bEnable, ply )
	if ( bEnable ) then
		self:SetOn( true )
	else
		self:SetOn( false )
	end
	
	if IsValid(self.interior) then
		self.interior.usecur=CurTime()+1
	end
	
	local tardis=self.tardis
	local interior=self.interior
	if IsValid(tardis) and IsValid(interior) then
		if tobool(GetConVarNumber("tardis_advanced"))==true then
			if (interior.flightmode==1 or interior.flightmode==2) and interior.step==4 then
				interior:UpdateAdv(ply, true)
			else
				interior:UpdateAdv(ply, false)
			end
		else
			local skycamera=self.interior.skycamera
			local typewriter=self.interior.typewriter
			local pos
			local ang
			if IsValid(skycamera) and skycamera.hitpos and skycamera.hitang then
				pos=skycamera.hitpos
				ang=skycamera.hitang
			end
			if IsValid(typewriter) and typewriter.pos and typewriter.ang then
				pos=typewriter.pos
				ang=typewriter.ang
			end
			if not self.tardis.moving and not self.tardis.repairing and pos and ang then
				local success=self.tardis:Go(pos, ang)
				if success then
					ply:ChatPrint("TARDIS moving to set destination.")
					if IsValid(skycamera) and skycamera.hitpos==pos and skycamera.hitang==ang then
						skycamera.hitpos=nil
						skycamera.hitang=nil
					end
					if IsValid(typewriter) and typewriter.pos==pos and typewriter.ang==ang then
						typewriter.pos=nil
						typewriter.ang=nil
					end
				end
			end
		end
		
		if self.tardis.moving and self.tardis.invortex and self.tardis.longflight then
			local success=self.tardis:LongReappear()
			if success then
				ply:ChatPrint("TARDIS materialising.")
			end
		end
	end
	
	if IsValid(self.tardis) then
		net.Start("TARDISInt-ControlSound")
			net.WriteEntity(self.tardis)
			net.WriteEntity(self)
			net.WriteString("tardis/control_throttle.wav")
		net.Broadcast()
	end
end