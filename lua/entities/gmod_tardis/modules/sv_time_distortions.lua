-- Support for time distortion generator by parar020100 and JEREDEK

local function TimeDistortionsPresent(pos, radius)
    for i,v in ipairs(ents.FindInSphere(pos, radius)) do
        if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
            return true
        end
    end
    return false
end

local function DistortionsInside(ent)
    local int_radius = ent.metadata.Interior.ExitDistance
    return TimeDistortionsPresent(ent.interior:GetPos(), int_radius)
end

local function DistortionsOutside(ent)
    return TimeDistortionsPresent(ent:GetPos(), 1000)
end

ENT:AddHook("ForceDematStart", "time_distortion_generators_outside", function(self)
    for i,v in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
        if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
            v:Break()
        end
    end
end)

ENT:AddHook("ShouldFailDemat", "time_distortions", function(self, force)
    if DistortionsOutside(self) and (DistortionsInside(self) or not force) then
        return true
    end
end)

ENT:AddHook("CanDemat", "time_distortions_only_inside", function(self, force)
    if not force and not self:GetData("redecorate") and DistortionsInside(self) and not DistortionsOutside(self) then
        return false
    end
end)

ENT:AddHook("HandleNoDemat", "time_distortions", function(self, pos, ang, callback, force)
    if not force and DistortionsInside(self) and not DistortionsOutside(self) then
        self:ForceDemat(pos, ang, callback)
    end
end)

ENT:AddHook("ShouldFailMat", "time_distortions_destination", function(self, dest_pos, dest_ang)
    if dest_pos ~= nil and dest_pos ~= self:GetPos() and TimeDistortionsPresent(dest_pos, 1000)
    then
        return true
    end
end)

ENT:AddHook("StopDemat", "time_distortions_inside", function(self, force)
    if DistortionsInside(self) then
        self:SetRandomDestination(self:GetData("flight", false))
    end
end)
