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
			self.flightloop:Stop()
		end
		if (self.flightmode or self.invortex) and self.visible and ((self.invortex and self.moving) or not self.moving) then
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
			self.flightloop2:ChangeVolume(0.5,0)
			self.flightloop2:Stop()
		end
		if self.flightloop2 and (self.flightmode or self.invortex) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) and interior and IsValid(interior) and ((self.invortex and self.moving) or not self.moving) then
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

net.Receive("TARDIS-GoLong", function()
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
				tardis:EmitSound("tardis/demat.wav", 100, pitch)
			end
			if interior and IsValid(interior) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) then
				interior:EmitSound("tardis/demat.wav", 100, pitch)
			end
		elseif IsValid(tardis) and tardis.visible then
			sound.Play("tardis/demat.wav", net.ReadVector(), 75, pitch)
		end
	end
end)

net.Receive("TARDIS-Reappear", function()
	local tardis=net.ReadEntity()
	local interior=net.ReadEntity()
	local exploded=tobool(net.ReadBit())
	local pitch=(exploded and 110 or 100)
	if tobool(GetConVarNumber("tardis_matsound"))==true then
		if IsValid(tardis) and LocalPlayer().tardis==tardis then
			if tardis.visible then
				tardis:EmitSound("tardis/mat.wav", 100, pitch)
			end
			if interior and IsValid(interior) and LocalPlayer().tardis_viewmode and not IsValid(LocalPlayer().tardis_skycamera) then
				interior:EmitSound("tardis/mat.wav", 100, pitch)
			end
		elseif IsValid(tardis) and tardis.visible then
			sound.Play("tardis/mat.wav", net.ReadVector(), 75, pitch)
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
		if tobool(GetConVarNumber("tardisint_repairsound"))==true then
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

local checkbox_options={
	{"Flight sounds", "tardis_flightsound"},
	{"Teleport sounds", "tardis_matsound"},
	{"Door sounds", "tardis_doorsound"},
	{"Lock sounds", "tardis_locksound"},
	{"Repair sounds", "tardisint_repairsound"},
	{"Power sounds", "tardisint_powersound"},
	{"Cloisterbell sound", "tardisint_cloisterbell"},
	{"Interior idle sounds", "tardisint_idlesound"},
	{"Interior control sounds", "tardisint_controlsound"},
	{"Interior dynamic light", "tardisint_dynamiclight"},
	{"Exterior dynamic light", "tardis_dynamiclight"},
	{"Tool tips", "tardisint_tooltip"},
}

for k,v in pairs(checkbox_options) do
	CreateClientConVar(v[2], "1", true)
end

hook.Add("PopulateToolMenu", "TARDIS-PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Doctor Who", "TARDIS_Options", "TARDIS", "", "", function(panel)
		panel:ClearControls()
		//Do menu things here
		
		local button = vgui.Create("DButton")
		button:SetText("Advanced Mode Help")
		button.DoClick = function(self)
			local window = vgui.Create( "DFrame" )
			window:SetSize( 415,220 )
			window:Center()
			window:SetTitle( "TARDIS Advanced Mode Help" )
			window:MakePopup()

			local DLabel = vgui.Create( "DLabel", window )
			DLabel:SetPos(7.5,30)
			DLabel:SetText(
				[[
				The TARDIS advanced flight mode requires the player to press a series of controls
				around the console area in order to successfully dematerialise.
				
				This build of the mod requires the following combination of controls (in order):
				
				1. Activate the flightmode (either Navigations Mode or Programmable Flight Mode)
				2. Dial the Helmic Regulator
				3. Apply the Locking Down Mechanism
				4. Release the Time-Rotor Handbrake
				5. Alternate the Space-Time Throttle
				
				Sounds will indicate if you have pressed the correct control or the wrong control.
				
				Happy dematerialising!
				]]
			)
			DLabel:SizeToContents()
		end
		panel:AddItem(button)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Double spawn trace (Admin Only)" )
		checkBox:SetToolTip( "This should fix some maps where the interior/skycamera doesn't spawn properly" )
		checkBox:SetValue( GetConVarNumber( "tardis_doubletrace" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-DoubleTrace")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
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
		checkBox:SetText( "Physical Damage (Admin Only)" )
		checkBox:SetToolTip( "This enables/disables physical damage from hitting stuff at high speeds." )
		checkBox:SetValue( GetConVarNumber( "tardis_physdamage" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-PhysDamage")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Advanced Mode (Admin Only)" )
		checkBox:SetToolTip( "This sets interior navigation to advanced, turn off for easy." )
		checkBox:SetValue( GetConVarNumber( "tardis_advanced" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-AdvancedMode")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Long Flight (BETA | Admin Only)" )
		checkBox:SetToolTip( "This sets flight mode to be longer, mostly for roleplay purposes." )
		checkBox:SetValue( GetConVarNumber( "tardis_longflight" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-LongFlight")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Lock doors during teleport (Admin Only)" )
		checkBox:SetToolTip( "This stops players from entering/leaving while it is teleporting." )
		checkBox:SetValue( GetConVarNumber( "tardis_teleportlock" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-TeleportLock")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		/* -- i feel people arnt going to know what this does and end up breaking everything, the above checkbox should help in most cases.
		local slider = vgui.Create( "DNumSlider" )
			slider:SetText( "Spawn Offset (Admin Only)" )
			slider:SetToolTip("Try the above checkbox first, this is a last resort for advanced users only.")
			slider:SetValue(0)
			slider:SetDecimals(0)
			slider:SetMin(-10000)
			slider:SetMax(5000)
			slider.val=0
			slider.OnValueChanged = function(self,val)
				if not (slider.val==val) then
					slider.val=val
					if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
						net.Start("TARDIS-SpawnOffset")
							net.WriteFloat(val)
						net.SendToServer()
					else
						chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
						chat.PlaySound()
					end
				end
			end
			panel:AddItem(slider)
			
		local button = vgui.Create( "DButton" )
		button:SetText( "Reset Spawn Offset" )
		button.DoClick = function(self)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				if slider then
					slider:SetValue(0)
				end
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to use this button.")
				chat.PlaySound()
			end
		end
		panel:AddItem(button)
		*/
		local checkboxes={}
		for k,v in pairs(checkbox_options) do
			CreateClientConVar(v[2], "1", true)
			local checkBox = vgui.Create( "DCheckBoxLabel" ) 
			checkBox:SetText( v[1] ) 
			checkBox:SetValue( GetConVarNumber( v[2] ) )
			checkBox:SetConVar( v[2] )
			panel:AddItem(checkBox)
			table.insert(checkboxes, checkBox)
		end
	end)
end)

hook.Add( "HUDShouldDraw", "TARDIS-HideHUD", function(name)
	local viewmode=LocalPlayer().tardis_viewmode
	if ((name == "CHudHealth") or (name == "CHudBattery")) and viewmode then
		return false
	end
end)