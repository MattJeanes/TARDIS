include('shared.lua')

CreateClientConVar("tardisint_idlesound", "1", true)
CreateClientConVar("tardisint_cloisterbell", "1", true)
CreateClientConVar("tardisint_dynamiclight", "1", true)
CreateClientConVar("tardisint_tooltip", "1", true)
 
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
	
	/*
	self.throttle={}
	self.throttle.active=false
	self.throttle.pos=0
	self.throttle.cur=0
	self.throttle.mode=1
	*/
end

net.Receive("TARDISInt-Throttle", function()
	local interior=net.ReadEntity()
	interior.throttle.active=true
end)

net.Receive("TARDISInt-SetParts", function()
	local tbl=net.ReadTable()
	for k,v in pairs(tbl) do
		v.tardis_part=true
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
		
		if tobool(GetConVarNumber("tardisint_idlesound"))==true and tardis.health and tardis.health >= 1 and not IsValid(LocalPlayer().tardis_skycamera) then
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
			if tardis.health and tardis.health > 0 then
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
			
			/*
			if self.throttle.active and CurTime()>self.throttle.cur then
				self.throttle.cur=CurTime()+0.03
				if self.throttle.pos==1 and self.throttle.mode==1 then
					self.throttle.mode=0
					self.throttle.active=false
				elseif self.throttle.pos==0 and self.throttle.mode==0 then
					self.throttle.mode=1
					self.throttle.active=false
				end
				
				self.throttle.pos=math.Approach( self.throttle.pos, self.throttle.mode, 0.05 )
				self:SetPoseParameter( "throttle", self.throttle.pos )
			end
			*/
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