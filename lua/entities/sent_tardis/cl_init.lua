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
	self.phasemode=not mode // it likes to reverse
end

CreateClientConVar("tardis_flightsound", "1", true)
CreateClientConVar("tardis_matsound", "1", true)
CreateClientConVar("tardis_doorsound", "1", true)
CreateClientConVar("tardis_locksound", "1", true)

function ENT:Initialize()
	if tobool(GetConVarNumber("tardis_flightsound"))==true then
		self.flightloop=CreateSound(self, "tardis/flight_loop.wav")
		self.flightloop:Stop()
	end
	self.health=100
	self.phasemode=false
	self.visible=true
	self.flightmode=false
	self.visible=true
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
	if tobool(GetConVarNumber("tardis_flightsound"))==false then
		if self.flightloop then
			self.flightloop:Stop()
			self.flightloop=nil
		end
		if self.flightloop2 then
			self.flightloop2:Stop()
			self.flightloop2=nil
		end
		return
	end
	if not self.flightloop then
		self.flightloop=CreateSound(self, "tardis/flight_loop.wav")
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
			local doppler = (pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/150
			if self.exploded then
				local r=math.random(90,130)
				self.flightloop:ChangePitch(math.Clamp(r+doppler,50,150),0.1)
			else
				self.flightloop:ChangePitch(math.Clamp(100+doppler,50,150),0.1)
			end
		else
			if self.exploded then
				local r=math.random(90,130)
				self.flightloop:ChangePitch(r,0.1)
			else
				self.flightloop:ChangePitch(100,0.1)
			end
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
	if self.flightloop2 and self.flightmode and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) and interior and IsValid(interior) and not self.moving then
		if !self.flightloop2:IsPlaying() then
			self.flightloop2:Play()
		end
		if self.exploded then
			local r=math.random(90,130)
			self.flightloop2:ChangePitch(r,0.1)
		else
			self.flightloop2:ChangePitch(100,0.1)
		end
	elseif self.flightloop2 then
		if self.flightloop2:IsPlaying() then
			self.flightloop2:Stop()
		end
	end
end

net.Receive("TARDIS-UpdateVis", function()
	local ent=net.ReadEntity()
	ent.visible=tobool(net.ReadBit())
end)

net.Receive("TARDIS-Phase", function()
	local ent=net.ReadEntity()
	ent.visible=tobool(net.ReadBit())
	ent:Phase(not ent.visible) // it likes to reverse
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

net.Receive("TARDIS-Go", function()
	local tardis=net.ReadEntity()
	if IsValid(tardis) then
		tardis.moving=true
	end
	local interior=net.ReadEntity()
	local exploded=tobool(net.ReadBit())
	local pitch=(exploded and 110 or 100)
	if tobool(GetConVarNumber("tardis_matsound"))==true then
		if IsValid(tardis) and LocalPlayer().tardis==tardis then
			if tardis.visible then
				tardis:EmitSound("tardis/full.wav", 100, pitch)
			end
			if interior and IsValid(interior) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) then
				interior:EmitSound("tardis/full.wav", 100, pitch)
			end
		elseif IsValid(tardis) and tardis.visible then
			sound.Play("tardis/demat.wav", net.ReadVector(), 75, pitch)
			sound.Play("tardis/mat.wav", net.ReadVector(), 75, pitch)
		end
	end
end)

net.Receive("TARDIS-Stop", function()
	tardis=net.ReadEntity()
	if IsValid(tardis) then
		tardis.moving=nil
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
	if IsValid(tardis) then
		tardis.locked=tobool(net.ReadBit())
		if tobool(GetConVarNumber("tardis_locksound"))==true then
			sound.Play("tardis/lock.wav", tardis:GetPos())
		end
	end
	if IsValid(interior) then
		if tobool(GetConVarNumber("tardis_locksound"))==true and not IsValid(LocalPlayer().tardis_skycamera) then
			sound.Play("tardis/lock.wav", interior:LocalToWorld(Vector(300,295,-79)))
		end
	end
end)

net.Receive("TARDIS-SetViewmode", function()
	LocalPlayer().tardis_viewmode=tobool(net.ReadBit())
	
	if LocalPlayer().tardis_viewmode and GetConVarNumber("r_rootlod")>0 then
		Derma_Query("The TARDIS Interior requires model detail on high, set now?", "TARDIS Interior", "Yes", function() RunConsoleCommand("r_rootlod", 0) end, "No", function() end)
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
	if tobool(GetConVarNumber("tardisint_repairsound"))==true and IsValid(interior) and repairing then
		sound.Play("tardis/repair.wav", interior:GetPos())
	end
end)

net.Receive("TARDIS-FinishRepair", function()
	local tardis=net.ReadEntity()
	if tobool(GetConVarNumber("tardisint_repairsound"))==true and IsValid(tardis) then
		sound.Play("tardis/repairfinish.wav", tardis:GetPos())
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

hook.Add("PopulateToolMenu", "TARDIS-PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Doctor Who", "TARDIS_Options", "TARDIS", "", "", function(panel)
		panel:ClearControls()
		//Do menu things here
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Take damage (Admin Only)" )
		checkBox:SetValue( GetConVarNumber( "tardis_takedamage" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-TakeDamage")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end			
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Allow phasing in flightmode (Admin Only)" )
		checkBox:SetValue( GetConVarNumber( "tardis_flightphase" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-FlightPhase")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Flight sounds" ) 
		checkBox:SetValue( GetConVarNumber( "tardis_flightsound" ) )
		checkBox:SetConVar( "tardis_flightsound" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Teleport sounds" ) 
		checkBox:SetValue( GetConVarNumber( "tardis_matsound" ) )
		checkBox:SetConVar( "tardis_matsound" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Door sounds" )
		checkBox:SetValue( GetConVarNumber( "tardis_doorsound" ) )
		checkBox:SetConVar( "tardis_doorsound" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Lock sounds" )
		checkBox:SetValue( GetConVarNumber( "tardis_locksound" ) )
		checkBox:SetConVar( "tardis_locksound" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Cloisterbell sound" ) 
		checkBox:SetValue( GetConVarNumber( "tardisint_cloisterbell" ) )
		checkBox:SetConVar( "tardisint_cloisterbell" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Interior idle sounds" ) 
		checkBox:SetValue( GetConVarNumber( "tardisint_idlesound" ) )
		checkBox:SetConVar( "tardisint_idlesound" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Dynamic lights" ) 
		checkBox:SetValue( GetConVarNumber( "tardisint_dynamiclight" ) )
		checkBox:SetConVar( "tardisint_dynamiclight" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Tool tips" ) 
		checkBox:SetValue( GetConVarNumber( "tardisint_tooltip" ) )
		checkBox:SetConVar( "tardisint_tooltip" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Repair sounds" ) 
		checkBox:SetValue( GetConVarNumber( "tardisint_repairsound" ) )
		checkBox:SetConVar( "tardisint_repairsound" )
		panel:AddItem(checkBox)
	end)
end)

hook.Add( "HUDShouldDraw", "TARDIS-HideHUD", function(name)
	local viewmode=LocalPlayer().tardis_viewmode
	if ((name == "CHudHealth") or (name == "CHudBattery")) and viewmode then
		return false
	end
end)