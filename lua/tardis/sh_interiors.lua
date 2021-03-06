-- Interiors

TARDIS.Metadata={}
TARDIS.MetadataRaw={}

local function merge(base,t)
	local copy=table.Copy(TARDIS.Metadata[base])
	table.Merge(copy,t)
	return copy
end

function TARDIS:AddInterior(t)
	self.Metadata[t.ID]=t
	self.MetadataRaw[t.ID]=t
	if t.Base and self.Metadata[t.Base] then
		self.Metadata[t.ID]=merge(t.Base,t)
	end
	for k,v in pairs(self.MetadataRaw) do
		if t.ID==v.Base then
			self.Metadata[k]=merge(v.Base,v)
		end
	end

	if t.Base~=true then
		local ent={}
		ent.Category="Doctor Who - TARDIS"
		ent.PrintName=t.Name
		if file.Exists("materials/vgui/entities/tardis/"..t.ID..".vtf", "GAME")
		then
			ent.IconOverride="vgui/entities/tardis/"..t.ID..".vtf"
		else
			ent.IconOverride="vgui/entities/tardis/"..t.ID..".png"
		end
		ent.ScriptedEntityType="tardis"
		list.Set("SpawnableEntities", t.ID, ent)
	end
end

function TARDIS:GetInterior(id)
	if self.Metadata[id]~= nil then
		return self.Metadata[id]
	end
end

function TARDIS:GetInteriors()
	return self.Metadata
end

hook.Add("PostGamemodeLoaded", "tardis-interiors", function()
	if not spawnmenu then return end
	spawnmenu.AddContentType("tardis", function(container, obj)
		if not obj.material then return end
		if not obj.nicename then return end
		if not obj.spawnname then return end

		local icon = vgui.Create("ContentIcon", container)
		icon:SetContentType("entity")
		icon:SetSpawnName(obj.spawnname)
		icon:SetName(obj.nicename)
		icon:SetMaterial(obj.material)
		icon:SetAdminOnly(obj.admin)
		icon:SetColor(Color(205, 92, 92, 255))
		icon.DoClick = function()
			RunConsoleCommand("tardis2_spawn", obj.spawnname)
			surface.PlaySound("ui/buttonclickrelease.wav")
		end

		if IsValid(container) then
			container:Add(icon)
		end

		return icon
	end)
end)

local function SpawnTARDIS(ply, metadataID)
	local entityName = "gmod_tardis"

	if not IsValid(ply) then
		return
	end
	if not gamemode.Call("PlayerSpawnSENT", ply, entityName) then
		return
	end

	local vStart = ply:EyePos()
	local vForward = ply:GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * 4096)
	trace.filter = ply

	local tr = util.TraceLine(trace)

	local sent = scripted_ents.GetStored(entityName).t
	ClassName = entityName
	local customData = {}
	customData.metadataID = metadataID
	local SpawnFunction = scripted_ents.GetMember(entityName, "SpawnFunction")
	if not SpawnFunction then
		return
	end
	local entity = SpawnFunction(sent, ply, tr, entityName, customData)

	if IsValid(entity) then
		entity:SetCreator(ply)
	end

	ClassName = nil

	local interior = TARDIS:GetInterior(metadataID)
	local printName = "TARDIS ("..interior.Name..")"

	if not IsValid(entity) then return end

	if IsValid(ply) then
		gamemode.Call("PlayerSpawnedSENT", ply, entity)
	end

	undo.Create("SENT")
	undo.SetPlayer(ply)
	undo.AddEntity(entity)
	undo.SetCustomUndoText("Undone " .. printName)
	undo.Finish(printName)

	ply:AddCleanup("sents", entity)
	entity:SetVar("Player", ply)

end
concommand.Add("tardis2_spawn", function(ply, cmd, args)
	SpawnTARDIS(ply, args[1])
end)

TARDIS:LoadFolder("interiors", nil, true)