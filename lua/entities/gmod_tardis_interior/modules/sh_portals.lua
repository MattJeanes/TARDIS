-- Handles portals for rendering, thanks to bliptec (http://facepunch.com/member.php?u=238641) for being a babe

if SERVER then
	local function isstuck(ply)
		local pos=ply:GetPos()
		local td={}
		td.start=pos
		td.endpos=pos
		td.mins=ply:OBBMins()
		td.maxs=ply:OBBMaxs()
		td.filter={ply}		
		local tr=util.TraceHull(td)
		return tr.Hit
	end
	
	ENT:AddHook("Initialize", "portals", function(self)
		self.portals={}
		self.portals[1]=ents.Create("linked_portal_door")
		self.portals[2]=ents.Create("linked_portal_door")
		
		self.portals[1]:SetDisappearDist(1000)
		self.portals[1]:SetWidth(44)
		self.portals[1]:SetHeight(91)
		self.portals[1]:SetPos(self.exterior:LocalToWorld(Vector(26,0,51.65)))
		self.portals[1]:SetAngles(self.exterior:GetAngles())
		self.portals[1]:SetExit(self.portals[2])
		self.portals[1]:SetParent(self.exterior)
		self.portals[1]:Spawn()
		self.portals[1]:Activate()
		
		self.portals[2]:SetDisappearDist(1000)
		self.portals[2]:SetWidth(60)
		self.portals[2]:SetHeight(91)
		self.portals[2]:SetPos(self:LocalToWorld(Vector(-1,-353.5,136)))
		self.portals[2]:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)))
		self.portals[2]:SetExit(self.portals[1])
		self.portals[2]:SetParent(self)
		self.portals[2]:Spawn()
		self.portals[2]:Activate()
		
		self.portals[1].TPHook = function(s,ent)
			if ent:IsPlayer() then
				self.exterior:PlayerEnter(ent,true)
			end
		end
		
		self.portals[2].TPHook = function(s,ent)
			if ent:IsPlayer() then
				self.exterior:PlayerExit(ent,false,true)
				if isstuck(ent) then
					self.exterior:PlayerExit(ent,true)
				end
			end
		end
	end)
	
	hook.Add("wp-shouldtp", "tardisint-portals", function(self,ent)
		local e=self:GetParent()
		if IsValid(e) then
			local class=e:GetClass()
			if class=="gmod_tardis" then
				if not e:DoorOpen() then
					return false
				end
			elseif class=="gmod_tardis_interior" then
				if not e.exterior:DoorOpen() then
					return false
				end
			end
		end
		if ent.TardisPart then return false end
	end)
else
	ENT:AddHook("ShouldDraw", "portals", function(self)
		if wp.drawing and wp.drawingent and wp.drawingent:GetParent()~=self:GetNetEnt("exterior") then
			return false
		end
	end)
	
	hook.Add("wp-shouldrender", "tardisint-portals", function(portal,exit,origin)
		local p=portal:GetParent()
		if IsValid(p) and (p:GetClass()=="gmod_tardis" or p:GetClass()=="gmod_tardis_interior") then
			if not p:DoorOpen() then
				return false
			end
		end
	end)
	
	-- Smoothly closes door (if open) as player reaches render limit TODO: make option (on default?)
	ENT:AddHook("Think", "portals", function(self)
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
			if ext:GetNetVar("doorstate") then
				local dist=GetViewEntity():GetPos():Distance(ext:GetPos())
				if dist>=750 and dist<=1000 then
					ext.DoorOverride=1-(dist-750)/250
				elseif dist>1000 and ext.DoorOverride and ext.DoorOverride ~= 0 then
					ext.DoorOverride=0
				elseif dist<800 and ext.DoorOverride then
					ext.DoorOverride=nil
				end
			elseif ext.DoorOverride then
				ext.DoorOverride = nil
			end
		end
	end)
end

hook.Add("wp-bullet", "tardisint-portals", function(ent)
	local e=ent:GetParent()
	if IsValid(e) then
		local class=e:GetClass()
		if class=="gmod_tardis" then
			if not e:DoorOpen() then
				return false
			end
		elseif class=="gmod_tardis_interior" then
			local ext=(SERVER and e.exterior or e:GetNetEnt("exterior"))
			if IsValid(ext) and (not ext:DoorOpen()) then
				return false
			end
		end
	end
end)