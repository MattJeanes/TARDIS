-- TARDIS debug pointer
-- Creators: Brundoob, Parar020100 and RyanM2711

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "TARDIS Debug Pointer"
ENT.Author			= "Brundoob"
ENT.Purpose			= "Print locations in the TARDIS"
ENT.Category		= "Doctor Who - TARDIS"
ENT.Spawnable 		= false
ENT.AdminOnly		= true

concommand.Add("tardis2_debug_pointer", function(ply,cmd,args)
	if not (ply:IsAdmin() and gamemode.Call("PlayerSpawnSENT", ply, "gmod_tardis_debug_pointer")) then return end
	local ent = ents.Create("gmod_tardis_debug_pointer")
	ent:SetCreator(ply)

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
	})

	local close_pos = ply:EyePos() + ply:EyeAngles():Forward() * 100

	if ply:EyePos():Distance(tr.HitPos) < ply:EyePos():Distance(close_pos) then
		ent:SetPos(tr.HitPos)
	else
		ent:SetPos(close_pos)
	end
	ent:Spawn()
	gamemode.Call("PlayerSpawnedSENT",ply,ent)
	undo.Create("TARDIS Debug Pointer")
	undo.AddEntity(ent)
	undo.SetPlayer(ply)
	undo.Finish()
	ply:AddCleanup("sents",ent)
end)