-- Parts

if SERVER then
	util.AddNetworkString("TARDIS-SetupPart")
end

function TARDIS.DrawOverride(self,override)
	if self.NoDraw then return end
	local int=self.interior
	local ext=self.exterior
	if IsValid(ext) then
		if (self.InteriorPart and IsValid(int) and ((int:CallHook("ShouldDraw")~=false)
		or (ext:DoorOpen()
			and (self.ClientDrawOverride and LocalPlayer():GetPos():Distance(ext:GetPos())<TARDIS:GetSetting("portals-closedist"))
			or (self.DrawThroughPortal and (int.scannerrender or (IsValid(wp.drawingent) and wp.drawingent:GetParent()==int)))
		))) or (self.ExteriorPart
			and (ext:CallHook("ShouldDraw")~=false)
			or self.ShouldDrawOverride
		) then
			self.parent:CallHook("PreDrawPart",self)
			if self.PreDraw then self:PreDraw() end
			if self.UseTransparencyFix and (not override) then
				render.SetBlend(0)
				self.o.Draw(self)
				render.SetBlend(1)
			else
				self.o.Draw(self)
			end
			if self.PostDraw then self:PostDraw() end
			self.parent:CallHook("DrawPart",self)
		end
	end
end

local overrides={
	["Draw"]={TARDIS.DrawOverride, CLIENT},
	["Initialize"]={function(self)
		if self.Animate then
			self.posepos=0
		end
		net.Start("TARDIS-SetupPart")
			net.WriteEntity(self)
		net.SendToServer()
	end, CLIENT},
	["Think"]={function(self)
		local int=self.interior
		local ext=self.exterior
		if self._init and IsValid(int) and IsValid(ext) then
			if (int:CallHook("ShouldThink")~=false) or (ext:DoorOpen() and self.ClientThinkOverride and LocalPlayer():GetPos():Distance(ext:GetPos())<TARDIS:GetSetting("portals-closedist")) or self.ExteriorPart then -- TODO: Improve
				if self.Animate then
					local target=self:GetOn() and 1 or 0
					self.posepos=math.Approach(self.posepos,target,FrameTime()*(self.AnimateSpeed or 1.5))
					self:SetPoseParameter("switch",self.posepos)
					self:InvalidateBoneCache()
				end
				return self.o.Think(self)
			end
		end
	end, CLIENT},
	["Use"]={function(self,a,...)
		local res
		local called=false
		if (not self.NoStrictUse) and IsValid(a) and a:IsPlayer() then
			if a:GetEyeTraceNoCursor().Entity==self then
				res=self.o.Use(self,a,...)
				called=true
			end
		else
			res=self.o.Use(self,a,...)
			called=true
		end
		if called then
			if SERVER and (res~=false) then
				self:SetOn(not self:GetOn())
			end
			return res
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

function TARDIS:GetPart(ent,id)
	return ent.parts and ent.parts[id] or NULL
end

local overridequeue={}
postinit=postinit or false -- local vars cannot stay on autorefresh
function TARDIS:AddPart(e)
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

hook.Add("InitPostEntity", "tardis-parts", function() 
	for k,v in pairs(overridequeue) do
		SetupOverrides(v)
	end
	overridequeue={}
	postinit=true
end)

local function GetData(self,e,id)
	local data={}
	if self.TardisExterior then
		if e.Exteriors and e.Exteriors[self.metadata.ID] then
			data=e.Exteriors[self.metadata.ID]
		elseif TARDIS.Exteriors and TARDIS.Exteriors[self.metadata.ID] then
			data=TARDIS.Exteriors[self.metadata.ID]
		elseif self.metadata.Exterior.Parts and self.metadata.Exterior.Parts[id] then
			data=self.metadata.Exterior.Parts[id]
		end
	elseif self.TardisInterior then
		if e.Interiors and e.Interiors[self.metadata.ID] then
			data=e.Interiors[self.metadata.ID]
		elseif TARDIS.Interiors and TARDIS.Interiors[self.metadata.ID] then
			data=TARDIS.Interiors[self.metadata.ID]
		elseif self.metadata.Interior.Parts and self.metadata.Interior.Parts[id] then
			data=self.metadata.Interior.Parts[id]
		end
	end
	return data
end

local function AutoSetup(self,e,id)
	local data=GetData(self,e,id)
	if not data then return end
	
	e:SetModel(e.model or e.Model)
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
		e:SetPos(self:LocalToWorld(e.pos or e.Pos or Vector(0,0,0)))
		e:SetAngles(self:LocalToWorldAngles(e.ang or e.Ang or Angle(0,0,0)))
	end
	if not e.Collision then
		e:SetParent(self)
	end
	if e.scale then
		e:SetModelScale(e.scale,0)
	end
	if e.NoShadow then
		e:DrawShadow(false)
	end
end

if SERVER then
	function TARDIS:SetupParts(ent)
		ent.parts={}
		local tempparts={}
		local data
		if ent.TardisExterior then
			data=ent.metadata.Exterior
		elseif ent.TardisInterior then
			data=ent.metadata.Interior
		end
		if data and data.Parts then
			for k,v in pairs(data.Parts) do
				local class=parts[k]
				if class then
					tempparts[k]=class
				end
			end
		end
		for k,v in pairs(parts) do
			if not tempparts[k] then
				local tbl=scripted_ents.GetStored(v).t
				local t
				if ent.TardisExterior then
					t=tbl.Exteriors
				elseif ent.TardisInterior then
					t=tbl.Interiors
				end
				if t and t[ent.metadata.ID] then
					tempparts[k]=v
				end
			end
		end
		for k,v in pairs(tempparts) do
			
			local e=ents.Create(v)
			Doors:SetupOwner(e,ent:GetCreator())
			e.exterior=(ent.TardisExterior and ent or ent.exterior)
			e.interior=(ent.TardisInterior and ent or ent.interior)
			e.parent=ent
			e.ExteriorPart=(e.parent==e.exterior)
			e.InteriorPart=(e.parent==e.interior)
			local data=GetData(ent,e,k)
			if type(data)=="table" then
				table.Merge(e,data)
			end
			if e.enabled==false then
				e:Remove()
				continue
			end
			if e.AutoSetup then
				AutoSetup(ent,e,k)
			end
			e:Spawn()
			e:Activate()
			ent:DeleteOnRemove(e)
			ent.parts[k]=e
		end
	end
	net.Receive("TARDIS-SetupPart", function(_,ply)
		local e=net.ReadEntity()
		if e.ID then
			net.Start("TARDIS-SetupPart")
				net.WriteEntity(e)
				net.WriteEntity(e.exterior)
				net.WriteEntity(e.interior)
				net.WriteBool(e.ExteriorPart)
				net.WriteBool(e.InteriorPart)
				net.WriteString(e.ID)
			net.Send(ply)
		end
	end)
else
	function TARDIS:SetupPart(e,name,ext,int,parent)
		if IsValid(e) and IsValid(parent) then
			e.exterior=ext
			e.interior=int
			e.parent=parent
			e.ExteriorPart=(parent==ext)
			e.InteriorPart=(parent==int)
			local data=GetData(parent,e,name)
			if type(data)=="table" then
				table.Merge(e,data)
			end
			if not parent.parts then parent.parts={} end
			parent.parts[name]=e
			if e.o.Initialize then
				e.o.Initialize(e)
			end
			e._init=true
		end
	end
	net.Receive("TARDIS-SetupPart", function(ply)
		local e=net.ReadEntity()
		local ext=net.ReadEntity()
		local int=net.ReadEntity()
		local extpart=net.ReadBool()
		local intpart=net.ReadBool()
		local parent
		if extpart then
			parent=ext
		else
			parent=int
		end
		local name = net.ReadString()
		if parent._init then
			TARDIS:SetupPart(e,name,ext,int,parent)
		else
			if not parent.partqueue then parent.partqueue = {} end
			parent.partqueue[e] = name
		end
	end)
end

-- Loads parts
TARDIS:LoadFolder("parts",false,true)