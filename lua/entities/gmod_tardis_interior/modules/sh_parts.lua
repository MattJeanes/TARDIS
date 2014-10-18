-- Adds matching interior door

if SERVER then
	util.AddNetworkString("TARDIS-SetupPart")
end

local parts={}
ENT.parts={}
function ENT:AddPart(t)
	table.insert(parts,t)
end

function ENT:GetPart(id)
	return self.parts[id] or NULL
end

local function SetupPart(int,e,n)
	-- Start dark magic
	e.part=n
	local t=parts[n]
	table.Merge(e,t)
	setmetatable(t,e:GetTable())
	t=e
	-- End dark magic
	
	-- Function overrides for optimisation TODO: Check ironic performance hit from overriding it this way
	if e.Think then
		local think=e.Think
		function e:Think()
			local int=self:GetNetEnt("interior")
			local check=(SERVER or (CLIENT and (int:CallHook("ShouldThink") or (int:DoorOpen() and self.ClientThinkOverride))))
			if check then
				think(self)
			end
		end
	end
	
	if e.Draw then
		local draw=e.Draw
		function e:Draw()
			local int=self:GetNetEnt("interior")
			local check=(SERVER or (CLIENT and (int:CallHook("ShouldDraw") or (int:DoorOpen() and self.ClientThinkOverride and LocalPlayer():GetPos():Distance(self:GetNetEnt("exterior"):GetPos())<500))))
			if check then
				draw(self)
			end
		end
	end
	
	int.parts[e.ID]=e
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
		for k,v in pairs(parts) do
			local e=ents.Create("gmod_tardis_part")
			e.owner=self.owner
			if CPPI then
				e:CPPISetOwner(self.owner)
			end
			e.interior=self
			e.exterior=self.exterior
			e:SetNetVar("interior",self)
			e:SetNetVar("exterior",self.exterior)
			
			SetupPart(self,e,k)
			e:Spawn()
			if e.AutoSetup then
				AutoSetup(e)
			end
			e:Activate()
			self:DeleteOnRemove(e)
		end
	end)
	
	net.Receive("TARDIS-SetupPart", function(_,ply)
		local e=net.ReadEntity()
		if e.part then
			net.Start("TARDIS-SetupPart")
				net.WriteEntity(e)
				net.WriteUInt(e.part,8) -- Max 255 parts, more than enough.. probably
			net.Send(ply)
		end
	end)
else
	net.Receive("TARDIS-SetupPart", function(ply)
		local e=net.ReadEntity()
		local n=net.ReadUInt(8)
		SetupPart(e:GetNetEnt("interior"),e,n)
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
