include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw() 
	if not self.phasing and self.visible then
		self:DrawModel()
		if WireLib then
			Wire_Render(self)
		end
	elseif self.phasing then
		if self.percent then
			if not self.phasemode and self.highPer <= 0 then
				self.phasing=false
			elseif self.phasemode and self.percent >= 1 then
				self.phasing=false
			end
		end
		
		self.percent = (self.phaselifetime - CurTime())
		self.highPer = self.percent + 0.5
		if self.phasemode then
			self.percent = (1-self.percent)-0.5
			self.highPer = self.percent+0.5
		end
		self.percent = math.Clamp( self.percent, 0, 1 )
		self.highPer = math.Clamp( self.highPer, 0, 1 )

		--Drawing original model
		local normal = self:GetUp()
		local origin = self:GetPos() + self:GetUp() * (self.maxs.z - ( self.height * self.highPer ))
		local distance = normal:Dot( origin )
		
		render.EnableClipping( true )
		render.PushCustomClipPlane( normal, distance )
			self:DrawModel()
		render.PopCustomClipPlane()
		
		local restoreT = self:GetMaterial()
		
		--Drawing phase texture
		render.MaterialOverride( self.wiremat )

		normal = self:GetUp()
		distance = normal:Dot( origin )
		render.PushCustomClipPlane( normal, distance )
		
		local normal2 = self:GetUp() * -1
		local origin2 = self:GetPos() + self:GetUp() * (self.maxs.z - ( self.height * self.percent ))
		local distance2 = normal2:Dot( origin2 )
		render.PushCustomClipPlane( normal2, distance2 )
			self:DrawModel()
		render.PopCustomClipPlane()
		render.PopCustomClipPlane()
		
		render.MaterialOverride( restoreT )
		render.EnableClipping( false )
	end
end

function ENT:Phase(mode)
	self.phasing=true
	self.phaseactive=true
	self.phaselifetime=CurTime()+1
	self.phasemode=mode
end

function ENT:Initialize()
	self.health=100
	self.phasemode=false
	self.visible=true
	self.flightmode=false
	self.visible=true
	self.power=true
	self.z=0
	self.phasedraw=0
	self.mins = self:OBBMins()
	self.maxs = self:OBBMaxs()
	self.wiremat = Material( "models/drmatt/tardis/phase" )
	self.height = self.maxs.z - self.mins.z
end

function ENT:OnRemove()
	if self.flightloop then
		self.flightloop:Stop()
		self.flightloop=nil
	end
	if self.flightloop2 then
		self.flightloop2:Stop()
		self.flightloop2=nil
	end
end

function ENT:Think()
	if tobool(GetConVarNumber("tardis_flightsound"))==true then
		if not self.flightloop then
			self.flightloop=CreateSound(self, "tardis/flight_loop.wav")
			self.flightloop:SetSoundLevel(90)
			self.flightloop:Stop()
		end
		if self.flightmode and self.visible and not self.moving then
			if !self.flightloop:IsPlaying() then
				self.flightloop:Play()
			end
			local e = LocalPlayer():GetViewEntity()
			if !IsValid(e) then e = LocalPlayer() end
			local tardis=LocalPlayer().tardis
			if not (tardis and IsValid(tardis) and tardis==self and e==LocalPlayer()) then
				local pos = e:GetPos()
				local spos = self:GetPos()
				local doppler = (pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200
				if self.exploded then
					local r=math.random(90,130)
					self.flightloop:ChangePitch(math.Clamp(r+doppler,80,120),0.1)
				else
					self.flightloop:ChangePitch(math.Clamp((self:GetVelocity():Length()/250)+95+doppler,80,120),0.1)
				end
				self.flightloop:ChangeVolume(GetConVarNumber("tardis_flightvol"),0)
			else
				if self.exploded then
					local r=math.random(90,130)
					self.flightloop:ChangePitch(r,0.1)
				else
					local p=math.Clamp(self:GetVelocity():Length()/250,0,15)
					self.flightloop:ChangePitch(95+p,0.1)
				end
				self.flightloop:ChangeVolume(0.75*GetConVarNumber("tardis_flightvol"),0)
			end
		else
			if self.flightloop:IsPlaying() then
				self.flightloop:Stop()
			end
		end
		
		local interior=self:GetNWEntity("interior",NULL)
		if not self.flightloop2 and interior and IsValid(interior) then
			self.flightloop2=CreateSound(interior, "tardis/flight_loop.wav")
			self.flightloop2:Stop()
		end
		if self.flightloop2 and (self.flightmode or self.invortex) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) and interior and IsValid(interior) and ((self.invortex and self.moving) or not self.moving) then
			if !self.flightloop2:IsPlaying() then
				self.flightloop2:Play()
				self.flightloop2:ChangeVolume(0.4,0)
			end
			if self.exploded then
				local r=math.random(90,130)
				self.flightloop2:ChangePitch(r,0.1)
			else
				local p=math.Clamp(self:GetVelocity():Length()/250,0,15)
				self.flightloop2:ChangePitch(95+p,0.1)
			end
		elseif self.flightloop2 then
			if self.flightloop2:IsPlaying() then
				self.flightloop2:Stop()
			end
		end
	else
		if self.flightloop then
			self.flightloop:Stop()
			self.flightloop=nil
		end
		if self.flightloop2 then
			self.flightloop2:Stop()
			self.flightloop2=nil
		end
	end
	
	if self.light_on and tobool(GetConVarNumber("tardis_dynamiclight"))==true then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local size=400
			local c=Color(255,255,255)
			dlight.Pos = self:GetPos() + self:GetUp() * 130
			dlight.r = c.r
			dlight.g = c.g
			dlight.b = c.b
			dlight.Brightness = 5
			dlight.Decay = size * 5
			dlight.Size = size
			dlight.DieTime = CurTime() + 1
		end
	end
end

net.Receive("TARDIS-UpdateVis", function()
	local ent=net.ReadEntity()
	ent.visible=tobool(net.ReadBit())
end)

net.Receive("TARDIS-Phase", function()
	local tardis=net.ReadEntity()
	local interior=net.ReadEntity()
	if IsValid(tardis) then
		tardis.visible=tobool(net.ReadBit())
		tardis:Phase(tardis.visible)
		if not tardis.visible and tobool(GetConVarNumber("tardis_phasesound"))==true then
			tardis:EmitSound("tardis/phase_enable.wav", 100, 100)
			if IsValid(interior) then
				interior:EmitSound("tardis/phase_enable.wav", 100, 100)
			end
		end
	end
end)

net.Receive("TARDIS-Explode", function()
	local ent=net.ReadEntity()
	ent.exploded=true
end)

net.Receive("TARDIS-UnExplode", function()
	local ent=net.ReadEntity()
	ent.exploded=false
end)

net.Receive("TARDIS-Flightmode", function()
	local ent=net.ReadEntity()
	ent.flightmode=tobool(net.ReadBit())
end)

net.Receive("TARDIS-SetInterior", function()
	local ent=net.ReadEntity()
	ent.interior=net.ReadEntity()
end)

local tpsounds={}
tpsounds[0]={ // normal
	"tardis/demat.wav",
	"tardis/mat.wav",
	"tardis/full.wav"
}
tpsounds[1]={ // fast demat
	"tardis/fast_demat.wav",
	"tardis/mat.wav",
	"tardis/full.wav"
}
tpsounds[2]={ // fast return
	"tardis/fastreturn_demat.wav",
	"tardis/fastreturn_mat.wav",
	"tardis/fastreturn_full.wav"
}
net.Receive("TARDIS-Go", function()
	local tardis=net.ReadEntity()
	if IsValid(tardis) then
		tardis.moving=true
	end
	local interior=net.ReadEntity()
	local exploded=tobool(net.ReadBit())
	local pitch=(exploded and 110 or 100)
	local long=tobool(net.ReadBit())
	local snd=net.ReadFloat()
	local snds=tpsounds[snd]
	if tobool(GetConVarNumber("tardis_matsound"))==true then
		if IsValid(tardis) and LocalPlayer().tardis==tardis then
			if tardis.visible then
				if long then
					tardis:EmitSound(snds[1], 100, pitch)
				else
					tardis:EmitSound(snds[3], 100, pitch)
				end
			end
			if interior and IsValid(interior) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) then
				if long then
					interior:EmitSound(snds[1], 100, pitch)
				else
					interior:EmitSound(snds[3], 100, pitch)
				end
			end
		elseif IsValid(tardis) and tardis.visible then
			local pos=net.ReadVector()
			local pos2=net.ReadVector()
			if pos then
				sound.Play(snds[1], pos, 75, pitch)
			end
			if pos2 and not long then
				sound.Play(snds[2], pos2, 75, pitch)
			end
		end
	end
end)

net.Receive("TARDIS-Stop", function()
	tardis=net.ReadEntity()
	if IsValid(tardis) then
		tardis.moving=nil
	end
end)

net.Receive("TARDIS-Reappear", function()
	local tardis=net.ReadEntity()
	local interior=net.ReadEntity()
	local exploded=tobool(net.ReadBit())
	local pitch=(exploded and 110 or 100)
	local snd=net.ReadFloat()
	local snds=tpsounds[snd]
	if tobool(GetConVarNumber("tardis_matsound"))==true then
		if IsValid(tardis) and LocalPlayer().tardis==tardis then
			if tardis.visible then
				tardis:EmitSound(snds[2], 100, pitch)
			end
			if interior and IsValid(interior) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) then
				interior:EmitSound(snds[2], 100, pitch)
			end
		elseif IsValid(tardis) and tardis.visible then
			sound.Play(snds[2], net.ReadVector(), 75, pitch)
		end
	end
end)

net.Receive("Player-SetTARDIS", function()
	local ply=net.ReadEntity()
	ply.tardis=net.ReadEntity()
end)

net.Receive("TARDIS-SetHealth", function()
	local tardis=net.ReadEntity()
	tardis.health=net.ReadFloat()
end)

net.Receive("TARDIS-SetLocked", function()
	local tardis=net.ReadEntity()
	local interior=net.ReadEntity()
	local locked=tobool(net.ReadBit())
	local makesound=tobool(net.ReadBit())
	if IsValid(tardis) then
		tardis.locked=locked
		if tobool(GetConVarNumber("tardis_locksound"))==true and makesound then
			sound.Play("tardis/lock.wav", tardis:GetPos())
		end
	end
	if IsValid(interior) then
		if tobool(GetConVarNumber("tardis_locksound"))==true and not IsValid(LocalPlayer().tardis_skycamera) and makesound then
			sound.Play("tardis/lock.wav", interior:LocalToWorld(Vector(300,295,-79)))
		end
	end
end)

net.Receive("TARDIS-SetViewmode", function()
	LocalPlayer().tardis_viewmode=tobool(net.ReadBit())
	LocalPlayer().ShouldDisableLegs=(not LocalPlayer().tardis_viewmode)
	
	if LocalPlayer().tardis_viewmode and GetConVarNumber("r_rootlod")>0 then
		Derma_Query("The TARDIS Interior requires model detail on high, set now?", "TARDIS Interior", "Yes", function() RunConsoleCommand("r_rootlod", 0) end, "No", function() end)
	end
		
end)

hook.Add( "ShouldDrawLocalPlayer", "TARDIS-ShouldDrawLocalPlayer", function(ply)
	if IsValid(ply.tardis) and not ply.tardis_viewmode then
		return false
	end
end)

net.Receive("TARDIS-PlayerEnter", function()
	if tobool(GetConVarNumber("tardis_doorsound"))==true then
		local ent1=net.ReadEntity()
		local ent2=net.ReadEntity()
		if IsValid(ent1) and ent1.visible then
			sound.Play("tardis/door.wav", ent1:GetPos())
		end
		if IsValid(ent2) and not IsValid(LocalPlayer().tardis_skycamera) then
			sound.Play("tardis/door.wav", ent2:LocalToWorld(Vector(300,295,-79)))
		end
	end
end)

net.Receive("TARDIS-PlayerExit", function()
	if tobool(GetConVarNumber("tardis_doorsound"))==true then
		local ent1=net.ReadEntity()
		local ent2=net.ReadEntity()
		if IsValid(ent1) and ent1.visible then
			sound.Play("tardis/door2.wav", ent1:GetPos())
		end
		if IsValid(ent2) and not IsValid(LocalPlayer().tardis_skycamera) then
			sound.Play("tardis/door2.wav", ent2:LocalToWorld(Vector(300,295,-79)))
		end
	end
end)

net.Receive("TARDIS-SetRepairing", function()
	local tardis=net.ReadEntity()
	local repairing=tobool(net.ReadBit())
	local interior=net.ReadEntity()
	if IsValid(tardis) then
		tardis.repairing=repairing
	end
	if IsValid(interior) and LocalPlayer().tardis==tardis and LocalPlayer().tardis_viewmode and tobool(GetConVarNumber("tardisint_powersound"))==true then
		if repairing then
			sound.Play("tardis/powerdown.wav", interior:GetPos())
		else
			sound.Play("tardis/powerup.wav", interior:GetPos())
		end
	end
end)

net.Receive("TARDIS-BeginRepair", function()
	local tardis=net.ReadEntity()
	if IsValid(tardis) then
		/*
		local mat=Material("models/drmatt/tardis/tardis_df")
		if not mat:IsError() then
			mat:SetTexture("$basetexture", "models/props_combine/metal_combinebridge001")
		end
		*/
	end
end)

net.Receive("TARDIS-FinishRepair", function()
	local tardis=net.ReadEntity()
	if IsValid(tardis) then
		if tobool(GetConVarNumber("tardisint_repairsound"))==true and tardis.visible then
			sound.Play("tardis/repairfinish.wav", tardis:GetPos())
		end
		/*
		local mat=Material("models/drmatt/tardis/tardis_df")
		if not mat:IsError() then
			mat:SetTexture("$basetexture", "models/drmatt/tardis/tardis_df")
		end
		*/
	end
end)

net.Receive("TARDIS-SetLight", function()
	local tardis=net.ReadEntity()
	local on=tobool(net.ReadBit())
	if IsValid(tardis) then
		tardis.light_on=on
	end
end)

net.Receive("TARDIS-SetPower", function()
	local tardis=net.ReadEntity()
	local on=tobool(net.ReadBit())
	local interior=net.ReadEntity()
	if IsValid(tardis) then
		tardis.power=on
	end
	if IsValid(interior) and LocalPlayer().tardis==tardis and LocalPlayer().tardis_viewmode and tobool(GetConVarNumber("tardisint_powersound"))==true then
		if on then
			sound.Play("tardis/powerup.wav", interior:GetPos())
		else
			sound.Play("tardis/powerdown.wav", interior:GetPos())
		end
	end
end)

net.Receive("TARDIS-SetVortex", function()
	local tardis=net.ReadEntity()
	local on=tobool(net.ReadBit())
	if IsValid(tardis) then
		tardis.invortex=on
	end
end)

surface.CreateFont( "HUDNumber", {font="Trebuchet MS", size=40, weight=900} )

hook.Add("HUDPaint", "TARDIS-DrawHUD", function()
	local p = LocalPlayer()
	local tardis = p.tardis
	if tardis and IsValid(tardis) and tardis.health and (tobool(GetConVarNumber("tardis_takedamage"))==true or tardis.exploded) then
		local health = math.floor(tardis.health)
		local n=0
		if health <= 99 then
			n=20
		end
		if health <= 9 then
			n=40
		end
		local col=Color(255,255,255)
		if health <= 20 then
			col=Color(255,0,0)
		end
		draw.RoundedBox( 0, 5, ScrH()-55, 220-n, 50, Color(0, 0, 0, 180) )
		draw.DrawText("Health: "..health.."%","HUDNumber", 15, ScrH()-52, col)
	end
end)

hook.Add("CalcView", "TARDIS_CLView", function( ply, origin, angles, fov )
	local tardis=LocalPlayer().tardis
	local viewent = LocalPlayer():GetViewEntity()
	if !IsValid(viewent) then viewent = LocalPlayer() end
	local dist= -300
	
	if tardis and IsValid(tardis) and viewent==LocalPlayer() and not LocalPlayer().tardis_viewmode then
		local pos=tardis:GetPos()+(tardis:GetUp()*50)
		local tracedata={}
		tracedata.start=pos
		tracedata.endpos=pos+ply:GetAimVector():GetNormal()*dist
		tracedata.mask=MASK_NPCWORLDSTATIC
		local trace=util.TraceLine(tracedata)
		local view = {}
		view.origin = trace.HitPos
		view.angles = angles
		return view
	end
end)

hook.Add( "HUDShouldDraw", "TARDIS-HideHUD", function(name)
	local viewmode=LocalPlayer().tardis_viewmode
	if ((name == "CHudHealth") or (name == "CHudBattery")) and viewmode then
		return false
	end
end)