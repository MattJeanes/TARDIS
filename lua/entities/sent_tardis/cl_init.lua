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

hook.Add("CalcView", "TARDIS_CLView", function( ply, origin, angles, fov )
	local tardis=LocalPlayer():GetNWEntity("TARDIS",nil)
	local dist= -300
	
	if tardis and IsValid(tardis) and LocalPlayer():GetNWBool("InTARDIS", false) then
		local view = {}
		view.origin = tardis:GetPos()+ply:GetAimVector():GetNormal()*dist
		view.angles = angles
		return view
	end
end)