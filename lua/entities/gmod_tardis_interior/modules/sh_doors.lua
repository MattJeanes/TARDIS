-- Adds matching interior door

if SERVER then
	ENT:AddHook("Initialize", "doors", function(self)
		util.PrecacheModel("models/drmatt/tardis/newdoor.mdl") -- Need to precache or model might be invisible clientside
	end)
else
	ENT:AddHook("Initialize", "doors", function(self)
		local e=ents.CreateClientProp("models/drmatt/tardis/newdoor.mdl")
		e:SetPos(self:LocalToWorld(Vector(-1.5,-309.5,82.7)))
		e:SetAngles(self:LocalToWorldAngles(Angle(0,-90,0)))
		e:SetParent(self)
		e:Spawn()
		e:Activate()
		self.door=e
	end)
	
	function ENT:DoorOpen()
		local ext=Entity(self:GetNetVar("exterior"))
		return ext:DoorOpen()
	end

	-- self:DeleteOnRemove(Entity) doesn't work clientside
	ENT:AddHook("OnRemove", "doors", function(self)
		if IsValid(self.door) then
			self.door:Remove()
			self.door=nil
		end
	end)

	ENT:AddHook("Think", "doors", function(self)
		local n=self:GetNetVar("exterior",false)
		if n then
			local ext=Entity(n)
			if IsValid(ext) and (ext.DoorPos ~= ext.DoorTarget) and IsValid(self.door) then
				self.door:SetPoseParameter("switch", ext.DoorPos)
				self.door:InvalidateBoneCache()
			end
		end
	end)
end