-- Handles portals for rendering, thanks to bliptec (http://facepunch.com/member.php?u=238641) for being a babe
if SERVER then
	ENT:AddHook("Initialize", "portals", function(self)
		self.portals={}
		for i=1,2 do
			self.portals[i]=ents.Create("linked_portal_door")
			self.portals[i]:SetWidth(45)
			self.portals[i]:SetHeight(85)
			self.portals[i]:SetDisappearDist(500)
		end
		self.portals[1]:SetPos(self.exterior:LocalToWorld(Vector(20,0,50)))
		self.portals[2]:SetPos(self:LocalToWorld(Vector(0,-300,143)))
		self.portals[1]:SetAngles(self.exterior:GetAngles())
		self.portals[2]:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)))
		self.portals[1]:SetExit(self.portals[2])
		self.portals[2]:SetExit(self.portals[1])
		self.portals[1]:SetParent(self.exterior)
		self.portals[2]:SetParent(self)
		for i=1,2 do
			self.portals[i]:Spawn()
			self.portals[i]:Activate()
		end
	end)
end