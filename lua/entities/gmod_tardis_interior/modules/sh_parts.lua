-- Adds matching interior door

if SERVER then
	util.AddNetworkString("TARDIS-SetupPart")
end

local overrides={
	["Draw"]={function(self)
		local int=self.interior
		local ext=self.exterior
		if IsValid(int) and IsValid(ext) then
			if (int:CallHook("ShouldDraw")~=false)
			or (ext:DoorOpen()
				and (self.ClientDrawOverride and LocalPlayer():GetPos():Distance(ext:GetPos())<1000)
				or (self.DrawThroughPortal and (int.scannerrender or (IsValid(wp.drawingent) and wp.drawingent:GetParent()==int)))
			) or self.ExteriorPart then
				return self.o.Draw(self)
			end
		end
	end, CLIENT},
	["Initialize"]={function(self)
		net.Start("TARDIS-SetupPart")
			net.WriteEntity(self)
		net.SendToServer()
	end, CLIENT},
	["Think"]={function(self)
		local int=self.interior
		local ext=self.exterior
		if self._init and IsValid(int) and IsValid(ext) then
			if (int:CallHook("ShouldThink")~=false) or (ext:DoorOpen() and self.ClientThinkOverride and LocalPlayer():GetPos():Distance(ext:GetPos())<1000) or self.ExteriorPart then -- TODO: Improve
				return self.o.Think(self)
			end
		end
	end, CLIENT},
	["Use"]={function(self,a,...)
		if (not self.NoStrictUse) and IsValid(a) and a:IsPlayer() then
			if a:GetEyeTraceNoCursor().Entity==self then
				return self.o.Use(self,a,...)
			end
		else
			return self.o.Use(self,a,...)
		end
	end, SERVER or CLIENT},
}

function SetupOverrides(e)
	local name=e.ClassName
	e.o={}
	for k,v in pairs(overrides) do
		local o=scripted_ents.GetMember(name, k)
		if o and v[2] then
			e.o[k] = o
			e[k] = v[1]
		end
	end
	scripted_ents.Register(e,name)
end

local parts={}

function ENT:GetPart(id)
	return self.parts[id] or NULL
end

local overridequeue={}
postinit=postinit or false -- local vars cannot stay on autorefresh
function ENT:AddPart(e)
	e=table.Copy(e)
	e.Base = "gmod_tardis_part"	
	local name="gmod_tardis_part_"..e.ID
	scripted_ents.Register(e,name)
	if postinit then
		SetupOverrides(e)
	else
		table.insert(overridequeue,e)
	end
	parts[e.ID]=name
end

hook.Add("InitPostEntity", "tardisi-parts", function() 
	for k,v in pairs(overridequeue) do
		SetupOverrides(v)
	end
	overridequeue={}
	postinit=true
end)

local function AutoSetup(self,e,id)
	local data={}
	if e.Interiors and e.Interiors[self.interior.ID] then
		data=e.Interiors[self.interior.ID]
	elseif self.interior.Parts and self.interior.Parts[id] then
		data=self.interior.Parts[id]
	end
	
	e:SetModel(data.model or e.Model)
	e:PhysicsInit( SOLID_VPHYSICS )
	e:SetMoveType( MOVETYPE_VPHYSICS )
	e:SetSolid( SOLID_VPHYSICS )
	e:SetRenderMode( RENDERMODE_TRANSALPHA )
	e:SetUseType( SIMPLE_USE )
	
	e.phys = e:GetPhysicsObject()
	if (e.phys:IsValid()) then
		e.phys:EnableMotion(e.Motion or false)
	end
	
	if not e.Collision then
		e:SetCollisionGroup( COLLISION_GROUP_WORLD ) -- Still works with USE, TODO: Find better way if possible (for performance reasons)
	end
	
	if e.AutoPosition ~= false then
		e:SetPos(self:LocalToWorld(data.pos or Vector(0,0,0)))
		e:SetAngles(self:LocalToWorldAngles(data.ang or Angle(0,0,0)))
	end
	
	if e.Weld then
		constraint.Weld(self,e,0,0,0,true,false)
	else
		e:SetParent(self)
	end
end

if SERVER then
	ENT:AddHook("Initialize", "parts", function(self)
		self.parts={}
		local tempparts={}
		if self.interior.Parts then
			for k,v in pairs(self.interior.Parts) do
				local class=parts[k]
				if class then
					tempparts[k]=class
				end
			end
		end
		for k,v in pairs(parts) do
			if not tempparts[k] then
				local t=scripted_ents.GetStored(v).t
				if t.Interiors and t.Interiors[self.interior.ID] then
					tempparts[k]=v
				end
			end
		end
		for k,v in pairs(tempparts) do
			local e=ents.Create(v)
			e:SetCreator(self:GetCreator())
			if CPPI then
				e:CPPISetOwner(self:GetCreator())
			end
			e.interior=self
			e.exterior=self.exterior
			if e.AutoSetup then
				AutoSetup(self,e,k)
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
				net.WriteEntity(e.exterior)
				net.WriteEntity(e.interior)
				net.WriteString(e.ID)
			net.Send(ply)
		end
	end)
else
	net.Receive("TARDIS-SetupPart", function(ply)
		local e=net.ReadEntity()
		local ext=net.ReadEntity()
		local int=net.ReadEntity()
		if IsValid(e) and IsValid(ext) and IsValid(int) then
			e.exterior=ext
			e.interior=int
			local name=net.ReadString()
			if not int.parts then int.parts={} end
			int.parts[name]=e
			if e.o.Initialize then
				e.o.Initialize(e)
			end
			e._init=true
		end
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