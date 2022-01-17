TARDIS:AddSetting({
	id="redecorate-interior",
	name="Redecoration interior",
	value="default",
	networked=true
})

local ext_migrated_data = {
	"floatfirst",
	"hads",
	"spindir",
	"spindir_prev",
	"spindir_before_door",
	"handbrake",
	"physlock",
	"demat-fast",
	"fastreturn-pos",
	"fastreturn-ang"
}
local int_migrated_data = {
	"security"
}

if SERVER then

	function ENT:Redecorate()
		local pos = self:GetPos() + Vector(0,0,0.02)
		local ang = self:GetAngles()

		local ent = TARDIS:SpawnTARDIS(self:GetCreator(), {
			metadataID = self:GetData("redecorate-interior"),
			finishrepair = true,
			pos = pos,
			ang = ang,
			parent = self,
		})

		self:SetData("redecorate_next", ent)

		-- make it dematerialised
		ent:SetData("demat",true)
		ent:SetData("vortex", 1)
		ent:SetData("vortexalpha", 1)
		ent:SetData("teleport",true)
		ent:SetData("alpha", 0)
		ent:SetBodygroup(1,0)
		ent:DrawShadow(false)
		for k,v in pairs(ent.parts) do
			v:DrawShadow(false)
		end

		ent:StopDemat()
		ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

		-- position
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetData("demat-pos",pos,true)
		ent:SetData("demat-ang",ang,true)
		ent:SetDestination(pos, ang)

		ent:GetPhysicsObject():Sleep()

		-- make it alive again
		self:SetData("repairing", false, true)
		self:ChangeHealth(TARDIS:GetSetting("health-max"))
		self:SetPower(true)


		-- migrate data
		local ext_saved_data = {}
		for k,v in ipairs(ext_migrated_data) do
			ext_saved_data[v] = self:GetData(v)
		end
		ent:SetData("parent-saved-ext-data", ext_saved_data, true)

		if IsValid(self.interior) then
			local int_saved_data = {}
			for k,v in ipairs(int_migrated_data) do
				int_saved_data[v] = self.interior:GetData(v)
			end
			ent:SetData("parent-saved-int-data", int_saved_data, true)
		end

		ent:SetData("cloak", self:GetData("cloak"), true) -- this one is separate since it needs to start from the beginning
		ent:SetData("prevortex-flight", self:GetData("flight", false), true)

		-- sonic (if exists)
		local owner = self:GetCreator()
		if owner and owner.linked_tardis == self then
			owner.linked_tardis = ent
			net.Start("Sonic-SetLinkedTARDIS")
				net.WriteEntity(ent)
			net.Send(owner)
		end


		-- fly away
		self:SetData("redecorate-demattime", CurTime())
		self:SetFastRemat(true)
		constraint.RemoveAll(self) -- dropped everything attached

		-- sync positions just in case
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		self:SetParent(ent)
		-- you can't interact with both at once

		self:Demat(pos, ang, nil, true)
	end

	ENT:AddHook("ShouldRedecorate", "health", function(self)
		return (self:GetData("redecorate",false) and self:GetData("redecorate-interior") ~= self.metadata.ID) and true or nil
	end)

	ENT:AddHook("ShouldTeleportPortal", "redecoration", function(self,portal,ent)
		if self:GetData("redecorate") or ent == self:GetData("redecorate_next") then
			return false
		end
	end)

	ENT:AddHook("Think", "redecorate_matnew", function(self)
		local demattime = self:GetData("redecorate-demattime")
		if demattime and CurTime() - demattime > 0.5 then
			self:SetData("redecorate-demattime", nil)

			local ent = self:GetData("redecorate_next")
			if IsValid(ent) then
				ent:SetFastRemat(true)
				ent:Mat()
			end
		end
	end)

	ENT:AddHook("StopDemat", "redecorate_dissapear", function(self)
		if self:GetData("redecorate") then
			self:Remove()
		end
	end)

	ENT:AddHook("StopMat", "redecorate_restore_data", function(self)
		if self:GetData("parent-saved-ext-data") then
			local ext_saved_data = self:GetData("parent-saved-ext-data")

			TARDIS:DebugPrintTable(ext_saved_data)

			for k,v in ipairs(ext_migrated_data) do
				self:SetData(v, ext_saved_data[v], true)
			end
			self:SetData("parent-saved-ext-data", nil, true)
		end
		if self:GetData("parent-saved-int-data") then
			if IsValid(self.interior) then
				local int_saved_data = self:GetData("parent-saved-int-data")

				for k,v in ipairs(int_migrated_data) do
					self.interior:SetData(v, int_saved_data[v], true)
				end
			end
			self:SetData("parent-saved-int-data", nil, true)
		end
	end)

else
	ENT:AddHook("Initialize", "redecorate-reset", function(self)
		if not IsValid(self) or (not LocalPlayer() == self:GetCreator()) then return end
		TARDIS:SetSetting("redecorate-interior",self.metadata.ID,true)
	end)
end