include('shared.lua')

local meta=FindMetaTable("Entity")
if not meta.SetCreator and not meta.GetCreator then
	function meta:SetCreator(creator)
		self._creator=creator
	end

	function meta:GetCreator(creator)
		return self._creator
	end
end

function ENT:Draw()
	self:DrawModel()
	if WireLib then
		Wire_Render(self)
	end
	if self._init then
		self:CallHook("Draw")
	end
end

net.Receive("TARDIS-Initialize", function(len)
	local ext=net.ReadEntity()
	local int=net.ReadEntity()
	local ply=net.ReadEntity()
	if IsValid(ext) and IsValid(ply) then
		ext.interior=int
		ext:SetCreator(ply)
		ext.phys=ext:GetPhysicsObject()
		ext:CallHook("Initialize")
		ext._init=true
	end
end)
function ENT:Initialize()
	net.Start("TARDIS-Initialize") net.WriteEntity(self) net.SendToServer()
end

function ENT:Think()
	if self._init then
		self:CallHook("Think")
	end
end