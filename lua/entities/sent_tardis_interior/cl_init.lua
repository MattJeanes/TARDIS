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

function ENT:Initialize()
	self.cloisterbell = CreateSound(self, "tardis/cloisterbell_loop.wav")
	self.cloisterbell:Stop()
end

function ENT:OnRemove()
	if self.cloisterbell then
		self.cloisterbell:Stop()
		self.cloisterbell=nil
	end
end

function ENT:Think()
	local tardis=self:GetNWEntity("TARDIS",NULL)
	if IsValid(tardis) and tardis.health and tardis.health < 21 then
		if self.cloisterbell and !self.cloisterbell:IsPlaying() then
			self.cloisterbell:Play()
		elseif not self.cloisterbell then
			self.cloisterbell = CreateSound(self, "tardis/cloisterbell_loop.wav")
			self.cloisterbell:Play()
		end
	end
end