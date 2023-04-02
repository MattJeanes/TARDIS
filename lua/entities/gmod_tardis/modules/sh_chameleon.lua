if SERVER then
	ENT:OnMessage("chameleon_change_exterior", function(self,data,ply)
		self:ChangeExterior(data[1])
	end)
end

function ENT:ChangeExterior(id)
	if CLIENT then
		self:SendMessage("chameleon_change_exterior", {id})
		return
	end

	if self.metadata.EnableClassicDoors ~= true or not IsValid(self.interior) then
		return
	end

	local new_metadata = TARDIS:CreateInteriorMetadata(id, self)
	local ext_md = new_metadata.Exterior

	self.metadata.Exterior = ext_md
	self.interior.metadata.Exterior = ext_md

	local intparts_md = self.interior.metadata.Interior.Parts
	if not intparts_md then return end

	intparts_md["door"] = new_metadata.Interior.Parts["door"]

	self:SetModel(ext_md.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	self.phys = self:GetPhysicsObject()

	self.phys:SetMass(ext_md.Mass)

	if (self.phys:IsValid()) then
        self.phys:Wake()
    end

	local portal = self.interior.portals.exterior
	local portal_md = ext_md.Portal

	if not IsValid(portal) then return end

	portal:SetParent(nil)
	portal:SetPos(self:LocalToWorld(portal_md.pos))
	portal:SetAngles(self:LocalToWorldAngles(portal_md.ang))
	portal:SetWidth(portal_md.width)
	portal:SetHeight(portal_md.height)
	portal:SetThickness(portal_md.thickness or 0)
	portal:SetInverted(portal_md.inverted)
	portal:SetParent(self)


	local intportal = self.interior.portals.interior
	local fallback = self.interior.Fallback.pos

	local floor = util.QuickTrace(self.interior:LocalToWorld(fallback) + Vector(0, 0, 30), Vector(0, 0, -0.1) * 99999999).HitPos
	floor = self.interior:WorldToLocal(floor)

	local prev_z_offset = self:GetData("chameleon_intportal_z_offset", 0)

	local intp_offset = intportal:GetExitPosOffset()
	local intp_offset_real_z = intp_offset.z - prev_z_offset

	local new_z_offset = 0.5 * portal:GetHeight() - self.interior:WorldToLocal(intportal:GetPos()).z + floor.z

	intportal:SetExitPosOffset(Vector(intp_offset.x, intp_offset.y, intp_offset_real_z + new_z_offset))
	self:SetData("chameleon_intportal_z_offset", new_z_offset)

	for k,v in pairs(self:GetParts()) do
		v:Remove()
	end

	TARDIS:SetupParts(self)

	local intdoor = self.interior:GetPart("door")
	if IsValid(intdoor) then
		intdoor:Remove()
	end



end