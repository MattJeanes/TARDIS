include('shared.lua')

function ENT:Draw()
	if self._init and self:CallHook("ShouldDraw")~=false then
		self:CallHook("PreDraw")
		self:DrawModel()
		if WireLib then
			Wire_Render(self)
		end
		self:CallHook("Draw")
	end
end

net.Receive("TARDISI-Initialize", function(len)
	local int=net.ReadEntity()
	local ext=net.ReadEntity()
	local ply=net.ReadEntity()
	local id=net.ReadString()
	if IsValid(int) and IsValid(ext) and IsValid(ply) then
		int.exterior=ext
		int:SetCreator(ply)
		int.phys=int:GetPhysicsObject()
		int.interior=int:GetInterior(id or "default")
		int:CallHook("Initialize")
		int._init=true
	end
end)
function ENT:Initialize()
	net.Start("TARDISI-Initialize") net.WriteEntity(self) net.SendToServer()
end

function ENT:Think()
	if self._init then
		self:CallHook("Think")
	end
end

hook.Add("PostDrawTranslucentRenderables", "TARDIS", function(...)
	for k,v in pairs(ents.FindByClass("gmod_tardis_interior")) do
		v:CallHook("PostDrawTranslucentRenderables",...)
	end
end)