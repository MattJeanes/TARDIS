-- Parts

if SERVER then
	util.AddNetworkString("TARDIS-SetupPart")
end

function TARDIS.DrawOverride(self,override)
	if self.NoDraw then return end
	local int=self.interior
	local ext=self.exterior

	if IsValid(ext) then

		if (self.InteriorPart and IsValid(int)
			and ((int:CallHook("ShouldDraw")~=false)
				or (ext:DoorOpen()
						and (self.ClientDrawOverride and LocalPlayer():GetPos():Distance(ext:GetPos()) < TARDIS:GetSetting("portals-closedist"))
						or (self.DrawThroughPortal and (int.scannerrender or (IsValid(wp.drawingent) and wp.drawingent:GetParent()==int)))
					)
				)
			) or (self.ExteriorPart
				and (ext:CallHook("ShouldDraw")~=false)
				or self.ShouldDrawOverride
			)
		then
			if self.parent:CallHook("ShouldDrawPart", self) == false then return end
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
		local call=false
		local res
		if (not self.NoStrictUse) and IsValid(a) and a:IsPlayer() and a:GetEyeTraceNoCursor().Entity~=self then return end
		local allowed, animate
		if self.ExteriorPart then
			allowed, animate = self.exterior:CallHook("CanUsePart",self,a)
		else
			allowed, animate = self.interior:CallHook("CanUsePart",self,a)
		end

		if self.PowerOffUse == false and not self.interior:GetPower() then
			TARDIS:ErrorMessage(a, "Power is disabled. This control is blocked.")
		else
			if allowed~=false then
				if self.HasUseBasic then
					self.UseBasic(self,a,...)
				end
				if SERVER and self.Control and (not self.HasUse) then
					TARDIS:Control(self.Control,a)
				else
					res=self.o.Use(self,a,...)
				end
			end

			if SERVER and (animate~=false) and (res~=false) then
				local on = self:GetOn()

				if self.PowerOffSound ~= false or self.interior:GetPower() then
					local part_sound = nil

					if self.SoundOff and on then
						part_sound = self.SoundOff
					elseif self.SoundOn and (not on) then
						part_sound = self.SoundOn
					elseif self.Sound then
						part_sound = self.Sound
					end

					if part_sound and self.SoundPos then
						sound.Play(part_sound, self:LocalToWorld(self.SoundPos))
					elseif part_sound then
						self:EmitSound(part_sound)
					end
				end
				self:SetOn(not on)
				if self.ExteriorPart then
					self.exterior:CallHook("PartUsed",self,a)
				elseif self.interior then
					self.interior:CallHook("PartUsed",self,a)
				end
			end
		end
		return res
	end, SERVER or CLIENT},
}

function SetupOverrides(e)
	local name=e.ClassName
	if not e.o then
		e.o={}
	end
	for k,v in pairs(overrides) do
		local o=scripted_ents.GetMember(name, k)
		if o and v[2] then
			if not e.o[k] then
				e.o[k] = o
			end
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
	local source = debug.getinfo(2).short_src
	if parts[e.ID] and parts[e.ID].source ~= source then
		error("Duplicate part ID registered: " .. e.ID .. " (exists in both " .. parts[e.ID].source .. " and " .. source .. ")")
	end
	e=table.Copy(e)
	e.HasUseBasic = e.UseBasic ~= nil
	e.HasUse = e.Use ~= nil
	e.Base = "gmod_tardis_part"
	local class="gmod_tardis_part_"..e.ID
	scripted_ents.Register(e,class)
	if postinit then
		SetupOverrides(e)
	else
		table.insert(overridequeue,e)
	end
	parts[e.ID] = { class = class, source = source }
end

function TARDIS:GetRegisteredPart(id)
	return scripted_ents.Get(parts[id].class)
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
		if e.CollisionUse == false then
			e:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		else
			e:SetCollisionGroup( COLLISION_GROUP_WORLD ) -- Still works with USE, TODO: Find better way if possible (for performance reasons)
		end
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

local function SetupPartMetadataControl(e)
	if (e.parent == e.interior) then
		controls_metadata = e.parent.metadata.Interior.Controls
	else
		controls_metadata = e.parent.metadata.Exterior.Controls
	end
	if controls_metadata ~= nil then
		if controls_metadata[e.ID] ~= nil then
			e.Control = controls_metadata[e.ID]
		end
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
				if v then
					local part=parts[k]
					if part then
						tempparts[k]=part.class
					else
						ErrorNoHaltWithStack("Attempted to create invalid part: " .. k)
					end
				end
			end
		end
		for k,v in pairs(parts) do
			if not tempparts[k] then
				local tbl=scripted_ents.GetStored(v.class).t
				local t
				if ent.TardisExterior then
					t=tbl.Exteriors
				elseif ent.TardisInterior then
					t=tbl.Interiors
				end
				if t and t[ent.metadata.ID] then
					tempparts[k]=v.class
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

			SetupPartMetadataControl(e)

			if e.enabled==false then
				e:Remove()
			else
				if e.AutoSetup then
					AutoSetup(ent,e,k)
				end
				e:Spawn()
				e:Activate()
				ent:DeleteOnRemove(e)
				ent.parts[k]=e
			end
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

			SetupPartMetadataControl(e)

			if not parent.parts then parent.parts={} end
			parent.parts[name]=e
			if e.matrixScale then
				local matrix = Matrix()
				matrix:Scale(e.matrixScale)
				e:EnableMatrix("RenderMultiply",matrix)
			end
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