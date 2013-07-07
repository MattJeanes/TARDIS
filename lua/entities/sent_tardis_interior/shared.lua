ENT.Type = "anim"
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end 
ENT.PrintName		= "TARDIS Interior"
ENT.Author			= "Dr. Matt"
ENT.Contact			= "mattjeanes23@gmail.com"
ENT.Instructions	= "Don't spawn this!"
ENT.Purpose			= "Time and Relative Dimension in Space's Interior"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Category		= "Doctor Who"

local function CanTouch(e)
	if e:GetClass()=="sent_tardis_interior" then
		return false
	end
end

hook.Add("PhysgunPickup", "TARDISInt-StopTouch", function(_,e)
	return CanTouch(e)
end)

hook.Add("OnPhysgunReload", "TARDISInt-StopTouch", function(_,p)
	local e = p:GetEyeTraceNoCursor().Entity
	return CanTouch(e)
end)

hook.Add("CanTool", "TARDISInt-StopTouch", function(_,tr)
	local e=tr.Entity
	return CanTouch(e)
end)

hook.Add("CanProperty", "TARDISInt-StopTouch", function(_,_,e)
	return CanTouch(e)
end)

hook.Add("PlayerNoClip", "TARDISInt-StopNoclip", function(ply)
	return (not ply.tardis_viewmode)
end)