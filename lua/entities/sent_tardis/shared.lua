ENT.Type = "anim"
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end 
ENT.PrintName		= "Legacy TARDIS"
ENT.Author			= "Dr. Matt"
ENT.Contact			= "mattjeanes23@gmail.com"
ENT.Instructions	= "Use with the sonic or press E to pilot."
ENT.Purpose			= "Time and Relative Dimension in Space"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Category		= "Doctor Who - TARDIS (Legacy)"

CreateConVar("tardis_takedamage", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_flightphase", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_doubletrace", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_physdamage", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_nocollideteleport", "1", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_advanced", "0", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_teleportlock", "0", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar("tardis_spawnoffset", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})

hook.Add("PhysgunDrop", "TARDIS-PhysgunDrop", function(ply,ent)
	if ent.physlocked then
		ent:GetPhysicsObject():EnableMotion(false)
	end
end)

hook.Add("OnPhysgunReload", "TARDIS-OnPhysgunReload", function(_,ply)
	local ent=ply:GetEyeTraceNoCursor().Entity
	if ent and IsValid(ent) and ent.physlocked then
		return false
	end
end)