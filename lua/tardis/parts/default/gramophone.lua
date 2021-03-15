-- Default Interior - Gramophone

local PART = {}
PART.ID = "default_gramophone"
PART.Name = "Default Gramophone"
PART.Model = "models/drmatt/tardis/gramophone.mdl"
PART.AutoSetup = true
PART.Collision = true

if SERVER then
	function PART:Use(ply)
		if not ply:IsPlayer() then return end
		TARDIS:PopToScreen("Music",ply)
	end
end

TARDIS:AddPart(PART)
