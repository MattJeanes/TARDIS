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
			Wire_Render(self.Entity)
		end
	elseif self.phasing then
		local normal = self:GetUp()
		local max=125
		if CurTime()>self.phasedraw then
			self.phasedraw=CurTime()+0.01
			if self.z >= max and self.phasemode then
				self.phaseactive=false
				self.visible=false
				self.phasing=false
			elseif self.z <= 0 and not self.phasemode then
				self.phaseactive=false
				self.visible=true
				self.phasing=false
			elseif self.phasemode and self.phaseactive then
				self.z=math.Clamp(self.z+2,0,max)
			elseif not self.phasemode and self.phaseactive then
				self.z=math.Clamp(self.z-2,0,max)
			end
		end
		
		local pos=self:LocalToWorld(Vector(0,0,self.z))
		local distance = normal:Dot( pos )
		local alreadyClipping = render.EnableClipping( true )
		render.PushCustomClipPlane( normal, distance )
			self:DrawModel()
			if WireLib then
				Wire_Render(self.Entity)
			end
		render.PopCustomClipPlane()
		render.EnableClipping( alreadyClipping ) -- We must not disable clipping if there is already clipping ongoing.
	end
end

function ENT:PhaseToggle()
	self.phasing=true
	self.phaseactive=true
	self.phasemode=(not self.phasemode)
end

CreateClientConVar("tardis_flightsound", "1", true)
CreateClientConVar("tardis_matsound", "1", true)

function ENT:Initialize()
	if tobool(GetConVarNumber("tardis_flightsound"))==true then
		self.flightloop=CreateSound(self, "tardis/flight_loop.wav")
		self.flightloop:Stop()
	end
	self.health=100
	self.phasemode=false
	self.visible=true
	self.z=0
	self.phasedraw=0
end

function ENT:OnRemove()
	if self.flightloop then
		self.flightloop:Stop()
		self.flightloop=nil
	end
end

function ENT:Think()
	if tobool(GetConVarNumber("tardis_flightsound"))==false then
		if self.flightloop then
			self.flightloop:Stop()
			self.flightloop=nil
		end
		return
	end
	if not self.flightloop then
		self.flightloop=CreateSound(self, "tardis/flight_loop.wav")
		self.flightloop:Stop()
	end
	local flying=self:GetNWBool("flightmode",false)
	local silent=self:GetNWBool("silent",false)
	if flying and not silent then
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
end

net.Receive("TARDIS-Phase", function()
	local ent=net.ReadEntity()
	ent:PhaseToggle()
end)

net.Receive("TARDIS-Explode", function()
	local ent=net.ReadEntity()
	ent.exploded=true
end)

net.Receive("TARDIS-Go", function()
	local tardis=net.ReadEntity()
	local silent=tardis:GetNWBool("silent",false)
	if tobool(GetConVarNumber("tardis_matsound"))==true and not silent then
		if IsValid(tardis) and LocalPlayer().tardis==tardis then
			tardis:EmitSound("tardis/full.wav")
		else
			sound.Play("tardis/demat.wav", net.ReadVector())
			sound.Play("tardis/mat.wav", net.ReadVector())
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

surface.CreateFont( "HUDNumber", {font="Trebuchet MS", size=40, weight=900} )

hook.Add("HUDPaint", "TARDIS-DrawHUD", function()
	local p = LocalPlayer()
	local tardis = p.tardis
	if tardis and IsValid(tardis) and (tobool(GetConVarNumber("tardis_takedamage"))==true or tardis.exploded) then
		local health = tardis.health
		local n=0
		if health <= 99 then
			n=20
		end
		if health <= 9 then
			n=40
		end
		draw.RoundedBox( 0, 5, ScrH()-55, 220-n, 50, Color(0, 0, 0, 180) )
		draw.DrawText("Health: "..math.floor(health).."%","HUDNumber", 15, ScrH()-52)
	end
end)

hook.Add("CalcView", "TARDIS_CLView", function( ply, origin, angles, fov )
	local tardis=LocalPlayer().tardis
	local viewent = LocalPlayer():GetViewEntity()
	if !IsValid(viewent) then viewent = LocalPlayer() end
	local dist= -300
	
	if tardis and IsValid(tardis) and viewent==LocalPlayer() then
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

hook.Add("PopulateToolMenu", "AddPopulateSCarAdminMenu", function()
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
		checkBox:SetText( "Flight sounds" ) 
		checkBox:SetValue( GetConVarNumber( "tardis_flightsound" ) )
		checkBox:SetConVar( "tardis_flightsound" )
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( "Teleport sounds" ) 
		checkBox:SetValue( GetConVarNumber( "tardis_matsound" ) )
		checkBox:SetConVar( "tardis_matsound" )
		panel:AddItem(checkBox)
	end)
end)