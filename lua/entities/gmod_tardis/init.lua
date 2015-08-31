AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
	self:SendData(ply)
end)

if not TARDIS.DoorsFound then
	function ENT:SpawnFunction(ply,...)
		if not scripted_ents.GetStored(self.Base) then
			ply:ChatPrint("Doors is not installed!")
			ply:SendLua('TARDIS:ShowDoorsPopup()')
			return
		end
	end
end