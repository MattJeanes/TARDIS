if SERVER then
    ENT:OnMessage("chameleon_change_exterior", function(self,data,ply)
        self:ChangeExterior(data[1], data[2])
    end)
else
    ENT:OnMessage("chameleon_exterior_animation", function(self,data,ply)
        local csound = self.metadata.Exterior.Sounds.Chameleon

        if TARDIS:GetSetting("sound") and csound then
            self:EmitSound(csound)
        end

        local delay = self.metadata.Exterior.ChameleonAnimTime / 2
        self:SetData("chameleon_animation", true, false)
        self:SetData("chameleon_animation_start", CurTime(), false)
        self:SetData("chameleon_animation_delay", delay, false)
        self:SetData("chameleon_animation_speed", 1.5 / delay, false)
        self:CallHook("ChameleonAnimationStarted")
    end)

    ENT:AddHook("Think", "chameleon_animation", function(self)
        local animating = self:GetData("chameleon_animation", false)
        if not animating then return end

        local start_time = self:GetData("chameleon_animation_start")
        local delay = self:GetData("chameleon_animation_delay")
        local speed = self:GetData("chameleon_animation_speed")

        local passed = CurTime() - start_time
        local first_half = (passed < delay)
        self:SetData("chameleon_animation_first_half", first_half)
        passed = passed % delay

        local target = first_half and -0.5 or 1
        local percent = self:GetData("chameleon-phase-percent",1)

        if percent == target then
            if not first_half then
                self:SetData("chameleon_animation", false)
                self:SetData("chameleon_animation_start", nil)
                self:CallHook("ChameleonAnimationFinished")
                self:SetData("chameleon-phase-lastTick", nil)
                self:SetData("chameleon_animation_first_half", nil)
            end
            return
        end

        local timepassed = CurTime() - self:GetData("chameleon-phase-lastTick",CurTime())
        self:SetData("chameleon-phase-lastTick", CurTime())

        local new_percent = math.Approach(percent, target, speed * timepassed) or 1
        local high_percent = math.Clamp(new_percent + 0.5, 0, 1) or 1
        self:SetData("chameleon-phase-percent", new_percent)
        self:SetData("chameleon-phase-highPercent", high_percent)

        local modelmaxs = self:GetData("modelmaxs")
        local modelheight = self:GetData("modelheight")

        local pos = self:GetPos() + self:GetUp() * (modelmaxs.z - (modelheight * high_percent))
        local pos2 = self:GetPos() + self:GetUp() * (modelmaxs.z - (modelheight * new_percent))

        self:SetData("phase-highPos", pos)
        self:SetData("phase-pos", pos2)
    end)

    ENT:AddHook("ShouldDrawPhaseAnimation", "chameleon", function(self)
        if self:GetData("chameleon_animation",false) then
            return true
        end
    end)
end

function ENT:ChangeExterior(id, animate)
    if CLIENT then
        self:SendMessage("chameleon_change_exterior", {id, animate})
        return
    end

    if self:CallCommonHook("CanChangeExterior", id) == false then
        self:SetData("chameleon_trying_to_change", id)
        return
    end
    self:SetData("chameleon_trying_to_change", nil)

    if not IsValid(self.interior) then
        return
    end

    local original_md = self:GetData("chameleon_original_exterior")
    if original_md == nil then
        self:SetData("chameleon_original_exterior", self.metadata.Exterior)
    end

    local ext_md = (id == "original") and original_md or TARDIS:CreateExteriorMetadata(id)

    local oldvortex = self.metadata.Exterior.Parts.vortex
    if oldvortex then
        ext_md.Parts.vortex = TARDIS:CopyTable(oldvortex)
    end

    self.metadata.Exterior = ext_md
    self.interior.metadata.Exterior = ext_md


    if animate then
        self:SendMessage("chameleon_exterior_animation")
    end

    local delay = (animate and self.metadata.Exterior.ChameleonAnimTime / 2) or 0

    self:Timer("chameleon_change", delay, function()
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
        TARDIS:SetupRandomSkin(self)

        self:SetData("chameleon_active", (id ~= "original"), true)
    end)
end

ENT:AddHook("ToggleDoor", "chameleon", function(self,open)
    if open then return end

    local id = self:GetData("chameleon_trying_to_change")
    if id then
        self:ChangeExterior(id, true)
    end
end)

ENT:AddHook("MatStart", "chameleon", function(self)
    local id = self:GetData("chameleon_trying_to_change")
    if id then
        self:ChangeExterior(id, false)
    end
end)

ENT:AddHook("ShouldDraw", "chameleon", function(self)
    if IsValid(self.interior) and self:GetData("chameleon_active", false)
        and wp.drawing and wp.drawingent == self.interior.portals.interior
    then
        return false
    end
end)

ENT:AddHook("ShouldDrawPart", "chameleon_door", function(self, part)
    if IsValid(self.interior) and self:GetData("chameleon_active", false) and part ~= nil
        and wp.drawing and wp.drawingent == self.interior.portals.interior
        and part == TARDIS:GetPart(self, "door")
    then
        return false
    end
end)
