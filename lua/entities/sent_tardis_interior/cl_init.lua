include('shared.lua')

CreateClientConVar("tardisint_idlesound", "1", true)
CreateClientConVar("tardisint_cloisterbell", "1", true)
 
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

function ENT:Think()
	local tardis=self:GetNWEntity("TARDIS",NULL)
	if IsValid(tardis) and LocalPlayer().tardis_viewmode and LocalPlayer().tardis==tardis then
		if tobool(GetConVarNumber("tardisint_cloisterbell"))==true then
			if tardis.health and tardis.health < 21 then
				if self.cloisterbell and !self.cloisterbell:IsPlaying() then
					self.cloisterbell:Play()
				elseif not self.cloisterbell then
					self.cloisterbell = CreateSound(self, "tardis/cloisterbell_loop.wav")
					self.cloisterbell:Play()
				end
			end
		else
			if self.cloisterbell and self.cloisterbell:IsPlaying() then
				self.cloisterbell:Stop()
				self.cloisterbell=nil
			end
		end
		
		if tobool(GetConVarNumber("tardisint_idlesound"))==true then
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
	end
end