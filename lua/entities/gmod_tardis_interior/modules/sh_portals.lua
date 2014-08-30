-- Handles portals for rendering, thanks to bliptec (http://facepunch.com/member.php?u=238641) for being a babe
if SERVER then
	ENT:AddHook("Initialize", "portals", function(self)
		self.portals={}
		self.portals[1]=ents.Create("linked_portal_door")
		self.portals[2]=ents.Create("linked_portal_door")
		
		self.portals[1]:SetDisappearDist(1000)
		self.portals[1]:SetWidth(44)
		self.portals[1]:SetHeight(91)
		self.portals[1]:SetPos(self.exterior:LocalToWorld(Vector(20,0,48)))
		self.portals[1]:SetAngles(self.exterior:GetAngles())
		self.portals[1]:SetExit(self.portals[2])
		self.portals[1]:SetParent(self.exterior)
		self.portals[1]:Spawn()
		self.portals[1]:Activate()
		
		self.portals[2]:SetDisappearDist(1000)
		self.portals[2]:SetWidth(40)
		self.portals[2]:SetHeight(80)
		self.portals[2]:SetPos(self:LocalToWorld(Vector(-1.5,-329.5,130.7)))
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
	end)
else
	ENT:AddHook("ShouldDraw", "portals", function(self)
		if wp.drawing then
			return true
		end
	end)
	
	hook.Add("wp-shouldrender", "tardisint-portals", function(portal,exit,origin)
		local p=portal:GetParent()
		if IsValid(p) and p:GetClass()=="gmod_tardis" then
			if not p:DoorOpen() then return false end
		end
	end)
end