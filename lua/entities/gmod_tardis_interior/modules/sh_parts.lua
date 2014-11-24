-- Adds matching interior door

if SERVER then
	util.AddNetworkString("TARDIS-SetupPart")
end

local parts={}

function ENT:GetPart(id)
	return self.parts[id] or NULL
end

function ENT:AddPart(e)
	e.Base = "gmod_tardis_part"	
	local name="gmod_tardis_part_"..e.ID
	scripted_ents.Register(e,name)
	parts[e.ID]=name
end

local function AutoSetup(e)
	e:SetModel(e.Model)
	e:PhysicsInit( SOLID_VPHYSICS )
	e:SetMoveType( MOVETYPE_VPHYSICS )
	e:SetSolid( SOLID_VPHYSICS )
	e:SetRenderMode( RENDERMODE_TRANSALPHA )
	e:SetUseType( SIMPLE_USE )
	
	e.phys = e:GetPhysicsObject()
	if (e.phys:IsValid()) then
		e.phys:EnableMotion(e.Motion or false)
	end
	
	if e.Collision==false then
		e:SetCollisionGroup( COLLISION_GROUP_WORLD ) -- Still works with USE, TODO: Find better way if possible (for performance reasons)
	end
end

if SERVER then
	ENT:AddHook("Initialize", "parts", function(self)
		self.parts={}
		for k,v in pairs(parts) do
			local e=ents.Create(v)
			e.owner=self.owner
			if CPPI then
				e:CPPISetOwner(self.owner)
			end
			e.interior=self
			e.exterior=self.exterior
			e:SetNetVar("interior",self)
			e:SetNetVar("exterior",self.exterior)
			if e.AutoSetup then
				AutoSetup(e)
			end
			e:Spawn()
			e:Activate()
			self:DeleteOnRemove(e)
			self.parts[k]=e
		end
	end)
	net.Receive("TARDIS-SetupPart", function(_,ply)
		local e=net.ReadEntity()
		if e.ID then
			net.Start("TARDIS-SetupPart")
				net.WriteEntity(e)
				net.WriteString(e.ID)
			net.Send(ply)
		end
	end)
else
	ENT:AddHook("Initialize", "parts", function(self)
		self.parts={}
	end)
	net.Receive("TARDIS-SetupPart", function(ply)
		local e=net.ReadEntity()
		local name=net.ReadString()
		e:GetNetEnt("interior").parts[name]=e
	end)
end

-- Loads parts
local folder = "entities/gmod_tardis_part/parts/"
local parts = file.Find( folder.."*.lua", "LUA" )
for _, plugin in ipairs( parts ) do
	if ( SERVER ) then
		AddCSLuaFile( folder..plugin )
	end
	include( folder..plugin )
end