include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	net.Start("TARDIS-SetupPart")
		net.WriteEntity(self)
	net.SendToServer()
end