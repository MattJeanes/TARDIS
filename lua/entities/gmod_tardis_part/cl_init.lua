include('shared.lua')

function ENT:Draw()
	if self.DoDraw then
		local int=self:GetNetEnt("interior")
		local ext=self:GetNetEnt("exterior")
		if IsValid(int) and IsValid(ext) then
			if int:CallHook("ShouldDraw") or (ext:DoorOpen() and self.ClientDrawOverride and LocalPlayer():GetPos():Distance(ext:GetPos())<500) or self.ExteriorPart then -- TODO: Improve
				self:DoDraw()
			end
		end
	end
end

function ENT:DoDraw()
	self:DrawModel()
end

function ENT:Initialize()
	net.Start("TARDIS-SetupPart")
		net.WriteEntity(self)
	net.SendToServer()
	if self.DoInitialize then
		self:DoInitialize()
	end
end

function ENT:Think()
	if self.DoThink then
		local int=self:GetNetEnt("interior")
		local ext=self:GetNetEnt("exterior")
		if IsValid(int) and IsValid(ext) then
			if int:CallHook("ShouldThink") or (ext:DoorOpen() and self.ClientThinkOverride and LocalPlayer():GetPos():Distance(ext:GetPos())<500) or self.ExteriorPart then -- TODO: Improve
				self:DoThink()
			end
		end
	end
end