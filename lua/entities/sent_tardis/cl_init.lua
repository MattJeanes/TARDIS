include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw() 
	self.Entity:DrawModel()
	if WireLib then
		Wire_Render(self.Entity)
	end
end

function ENT:Initialize()
	self.flightloop=CreateSound(self, "tardis/flight_loop.wav")
	self.flightloop:Stop()
end

function ENT:OnRemove()
	self.flightloop:Stop()
	self.flightloop=nil
end

function ENT:Think()
	if not self.flightloop then
		self:Initialize()
	end
	local flying=self:GetNWBool("flightmode",false)
	if flying then
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
			self.flightloop:ChangePitch(math.Clamp(100+doppler,50,150),0.1)
		else
			self.flightloop:ChangePitch(100,0.1)
		end
	else
		if self.flightloop:IsPlaying() then
			self.flightloop:Stop()
		end
	end
end

net.Receive("Player-SetTARDIS", function()
	local ply=net.ReadEntity()
	ply.tardis=net.ReadEntity()
end)


hook.Add("CalcView", "TARDIS_CLView", function( ply, origin, angles, fov )
	local tardis=LocalPlayer().tardis
	local viewent = LocalPlayer():GetViewEntity()
	if !IsValid(viewent) then viewent = LocalPlayer() end
	local dist= -300
	
	if tardis and IsValid(tardis) and viewent==LocalPlayer() then
		local view = {}
		view.origin = tardis:GetPos()+(tardis:GetUp()*50)+ply:GetAimVector():GetNormal()*dist
		view.angles = angles
		return view
	end
end)