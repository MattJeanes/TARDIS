include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
	if LocalPlayer().tardis_viewmode and self:GetNWEntity("TARDIS",NULL)==LocalPlayer().tardis then
		self:DrawModel()
		if WireLib then
			Wire_Render(self)
		end
	end
end

function ENT:OnRemove()
	if self.cloisterbell then
		self.cloisterbell:Stop()
		self.cloisterbell=nil
	end
	if self.idlesound then
		self.idlesound:Stop()
		self.idlesound=nil
	end
	if self.idlesound2 then
		self.idlesound2:Stop()
		self.idlesound2=nil
	end
end

function ENT:Initialize()
	self.timerotor={}
	self.timerotor.pos=0
	self.timerotor.mode=1
end

net.Receive("TARDISInt-SetParts", function()
	local count=net.ReadFloat()
	for i=1,count do
		local ent=net.ReadEntity()
		ent.tardis_part=true
	end
end)

net.Receive("TARDISInt-UpdateAdv", function()
	local success=tobool(net.ReadBit())
	if success then
		surface.PlaySound("tardis/advflight_good.wav")
	else
		surface.PlaySound("tardis/advflight_bad.wav")
	end
end)

net.Receive("TARDISInt-SetAdv", function()
	local interior=net.ReadEntity()
	local ply=net.ReadEntity()
	local mode=net.ReadFloat()
	if IsValid(interior) and IsValid(ply) and mode then
		if ply==LocalPlayer() then
			surface.PlaySound("tardis/advflight_good.wav")
		end
		interior.flightmode=mode
	end
end)

function ENT:Think()
	local tardis=self:GetNWEntity("TARDIS",NULL)
	if IsValid(tardis) and LocalPlayer().tardis_viewmode and LocalPlayer().tardis==tardis then
		if tobool(GetConVarNumber("tardisint_cloisterbell"))==true and not IsValid(LocalPlayer().tardis_skycamera) then
			if tardis.health and tardis.health < 21 then
				if self.cloisterbell and !self.cloisterbell:IsPlaying() then
					self.cloisterbell:Play()
				elseif not self.cloisterbell then
					self.cloisterbell = CreateSound(self, "tardis/cloisterbell_loop.wav")
					self.cloisterbell:Play()
				end
			else
				if self.cloisterbell and self.cloisterbell:IsPlaying() then
					self.cloisterbell:Stop()
					self.cloisterbell=nil
				end
			end
		else
			if self.cloisterbell and self.cloisterbell:IsPlaying() then
				self.cloisterbell:Stop()
				self.cloisterbell=nil
			end
		end
		
		if tobool(GetConVarNumber("tardisint_idlesound"))==true and tardis.health and tardis.health >= 1 and not IsValid(LocalPlayer().tardis_skycamera) and not tardis.repairing then
			if self.idlesound and !self.idlesound:IsPlaying() then
				self.idlesound:Play()
			elseif not self.idlesound then
				self.idlesound = CreateSound(self, "tardis/interior_idle_loop.wav")
				self.idlesound:Play()
			end
			
			if self.idlesound2 and !self.idlesound2:IsPlaying() then
				self.idlesound2:Play()
			elseif not self.idlesound2 then
				self.idlesound2 = CreateSound(self, "tardis/interior_idle2_loop.wav")
				self.idlesound2:Play()
			end
		else
			if self.idlesound and self.idlesound:IsPlaying() then
				self.idlesound:Stop()
				self.idlesound=nil
			end
			if self.idlesound2 and self.idlesound2:IsPlaying() then
				self.idlesound2:Stop()
				self.idlesound2=nil
			end
		end
		
		if not IsValid(LocalPlayer().tardis_skycamera) and tobool(GetConVarNumber("tardisint_dynamiclight"))==true then
			if tardis.health and tardis.health > 0 and not tardis.repairing then
				local dlight = DynamicLight( self:EntIndex() )
				if ( dlight ) then
					local size=1024
					local c=Color(255,50,0)
					if tardis.health < 21 then
						c=Color(200,0,0)
					end
					dlight.Pos = self:LocalToWorld(Vector(0,0,120))
					dlight.r = c.r
					dlight.g = c.g
					dlight.b = c.b
					dlight.Brightness = 5
					dlight.Decay = size * 5
					dlight.Size = size
					dlight.DieTime = CurTime() + 1
				end
				
				local dlight2 = DynamicLight( self:EntIndex()+10000 )
				if ( dlight2 ) then
					local size=1024
					local c=Color(0,255,0)
					dlight2.Pos = self:LocalToWorld(Vector(0,0,-50))
					dlight2.r = c.r
					dlight2.g = c.g
					dlight2.b = c.b
					dlight2.Brightness = 2
					dlight2.Decay = size * 5
					dlight2.Size = size
					dlight2.DieTime = CurTime() + 1
				end
			end
			
			if (self.timerotor.pos>0 and not tardis.moving or tardis.flightmode) or (tardis.moving or tardis.flightmode) then
				if self.timerotor.pos==1 then
					self.timerotor.mode=0
				elseif self.timerotor.pos==0 and (tardis.moving or tardis.flightmode) then
					self.timerotor.mode=1
				end
				
				self.timerotor.pos=math.Approach( self.timerotor.pos, self.timerotor.mode, FrameTime()*1.1 )
				self:SetPoseParameter( "glass", self.timerotor.pos )
			end
		end
	else
		if self.cloisterbell then
			self.cloisterbell:Stop()
			self.cloisterbell=nil
		end
		if self.idlesound then
			self.idlesound:Stop()
			self.idlesound=nil
		end
		if self.idlesound2 then
			self.idlesound2:Stop()
			self.idlesound2=nil
		end
	end
end