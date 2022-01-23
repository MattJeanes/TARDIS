TARDIS:AddSetting({
	id="redecorate-interior",
	name="Redecoration interior",
	value="default",
	networked=true
})

local ext_saved_data_names = {
	"cloak",
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
local int_saved_data_names = {
	"security"
}

if SERVER then

	ENT:AddHook("ShouldRedecorate", "redecorate_toggled", function(self)
		return (self:GetData("redecorate",false) and self:GetData("redecorate-interior") ~= self.metadata.ID) and true or nil
	end)

	function ENT:Redecorate()

		local ply = self:GetCreator()

		self:SetData("repairing", false, true)
		self:ChangeHealth(TARDIS:GetSetting("health-max"))
		self:SetPower(true)

		-- save tardis state
		local ext_saved_data = {}
		local int_saved_data = {}
		for k,v in ipairs(ext_saved_data_names) do
			ext_saved_data[v] = self:GetData(v)
		end
		if IsValid(self.interior) then
			for k,v in ipairs(int_saved_data_names) do
				int_saved_data[v] = self.interior:GetData(v)
			end
		end

		local child = TARDIS:SpawnTARDIS(ply, {
			pos = self:GetPos(),
			metadataID = self:GetData("redecorate-interior") or "default",
			redecorate_parent = self,
			ext_data = ext_saved_data,
			int_data = int_saved_data,
		})

		if not IsValid(child) then
			ErrorNoHalt("Redecoration failed: failed to spawn the replacement")
		end
		return IsValid(child) -- if gone wrong, finish repair
	end

	ENT:AddHook("StopDemat", "redecorate_remove_parent", function(self)
		if self:GetData("redecorate") then
			local child = self:GetData("redecorate_child")
			if IsValid(child) then
				child:SetData("redecorate_parent", nil, true)
			end
			self:Remove()
		end
	end)

	ENT:AddHook("MatStart", "redecorate_sync", function(self)
		local parent = self:GetData("redecorate_parent")
		if not parent then return end

		parent:ForcePlayerDrop()
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetPos(parent:GetPos())
		self:SetAngles(parent:GetAngles())
		parent:SetParent(self)
	end)

	ENT:AddHook("StopMat", "redecorate_sync", function(self)
		local parent_vortex = self:GetData("redecorate_parent_vortex")

		if parent_vortex then
			self:SetFastRemat(false)
			self:SetData("redecorate_parent_vortex", nil, true)
		end
	end)

	ENT:AddHook("CustomData", "redecorate_child", function(self, customdata)
		local parent = customdata.redecorate_parent
		if parent then
			self:SetData("redecorate_parent", parent)
			parent:SetData("redecorate_child", self)

			self:SetPos(parent:GetPos())
			self:SetAngles(parent:GetAngles())

			self:SetData("redecorate_parent_int_data", customdata.int_data, true)
			self:SetData("redecorate_parent_ext_data", customdata.ext_data, true)

			local vortex = (not parent:GetData("demat-fast"))
			self:SetData("redecorate_parent_vortex", vortex, true)
		end
	end)

	ENT:AddHook("Initialize", "redecorate_child", function(self)
		local parent = self:GetData("redecorate_parent")
		if not parent then return end

		local phys = self:GetPhysicsObject()
		phys:Sleep()

		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	end)

	ENT:AddHook("PostInitialize", "redecorate_child", function(self)
		local parent = self:GetData("redecorate_parent")
		if not parent then return end

		self:ForceDematState()

		local ext_saved_data = self:GetData("redecorate_parent_ext_data")
		if ext_saved_data then
			for name,value in pairs(ext_saved_data) do
				self:SetData(name, value, true)
			end
		end
		self:SetData("redecorate_parent_ext_data", nil, true)
		self:CallHook("MigrateData", parent)

		self:SendMessage("MigrateData", function()
			net.WriteEntity(parent)
		end)

		local phys = self:GetPhysicsObject()

		constraint.RemoveAll(parent) -- drop everything attached
		parent:SetFastRemat(true)

		parent:SetPhyslock(true)
		parent:ForcePlayerDrop()
		parent:Demat(nil, nil, nil, true)
		parent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

		self:Timer("redecorate_materialise", 1, function()
			parent:ForcePlayerDrop()
			parent:SetData("redecorate_mat_started", true)

			phys:Wake()
			self:SetFastRemat(true)
			self:Mat()

			local ply = self:GetCreator()
			if ply and ply.linked_tardis == parent then
				ply.linked_tardis = self
				net.Start("Sonic-SetLinkedTARDIS")
					net.WriteEntity(self)
				net.Send(ply)
			end
		end)

	end)

	ENT:AddHook("ShouldTeleportPortal", "redecorate", function(self,portal,ent)
		if self:GetData("redecorate") or ent == self:GetData("redecorate_next") then
			return false
		end
	end)

	hook.Add("AllowPlayerPickup", "tardis_redecorate", function(ply, ent)
		if ent.TardisExterior and (ent:GetData("redecorate_parent") or ent:GetData("redecorate_mat_started")) then
			return false
		end
	end)

else -- CLIENT
	ENT:OnMessage("MigrateData", function(self)
		local parent=net.ReadEntity()
		self:CallHook("MigrateData", parent)
	end)

	ENT:AddHook("Initialize", "redecorate-reset", function(self)
		if not IsValid(self) or (not LocalPlayer() == self:GetCreator()) then return end
		TARDIS:SetSetting("redecorate-interior",self.metadata.ID,true)
	end)
end