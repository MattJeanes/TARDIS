-- Support for time distortion generator by parar020100 and JEREDEK

local function TimeDistortionsPresent(pos, radius)
	for i,v in ipairs(ents.FindInSphere(pos, radius)) do
		if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
			return true
		end
	end
	return false
end

local function AreDistortionsInside(ent)
	local int_radius = ent.metadata.Interior.ExitDistance
	return TimeDistortionsPresent(ent.interior:GetPos(), int_radius)
end

local function AreDistortionsOutside(ent)
	return TimeDistortionsPresent(ent:GetPos(), 1000)
end

ENT:AddHook("ForceDematStart", "time_distortion_generators_outside", function(self)
	for i,v in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
		if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
			v:Break()
		end
	end
end)

ENT:AddHook("FailDemat", "time_distortions", function(self, force)
	if AreDistortionsOutside(self) and (AreDistortionsInside(self) or not force) then
		return true
	end
end)

ENT:AddHook("CanDemat", "time_distortions_only_inside", function(self, force)
	if not force and AreDistortionsInside(self) and not AreDistortionsOutside(self) then
		return false
	end
end)

ENT:AddHook("HandleNoDemat", "time_distortions", function(self, pos, ang, callback, force)
	if not force and AreDistortionsInside(self) and not AreDistortionsOutside(self) then
		self:ForceDemat(pos, ang, callback)
	end
end)

ENT:AddHook("FailMat", "time_distortions_destination", function(self, dest_pos, dest_ang)
	if dest_pos ~= nil and dest_pos ~= self:GetPos() and TimeDistortionsPresent(dest_pos, 1000)
	then
		return true
	end
end)

ENT:AddHook("StopDemat", "time_distortions_inside", function(self, force)
	if AreDistortionsInside(self) then
		self:SetRandomDestination(self:GetData("flight", false))
	end
end)
