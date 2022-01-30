-- Support for time distortion generator by parar020100 and JEREDEK

local function TimeDistortionsPresent(pos, radius)
	for i,v in ipairs(ents.FindInSphere(pos, radius)) do
		if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
			return true
		end
	end
	return false
end

ENT:AddHook("ForceDematStart", "time_distortion_generators_outside", function(self)
	for i,v in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
		if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
			v:Break()
		end
	end
end)

ENT:AddHook("FailDemat", "time_distortions_outside", function(self, force)
	if not force and TimeDistortionsPresent(self:GetPos(), 1000) then
		return true
	end
end)

ENT:AddHook("FailDemat", "time_distortions_inside", function(self, force)
	local int_radius = self.metadata.Interior.ExitDistance
	if TimeDistortionsPresent(self.interior:GetPos(), int_radius) then
		return true
	end
end)

ENT:AddHook("FailMat", "time_distortions_destination", function(self, dest_pos, dest_ang)
	if dest_pos ~= nil and dest_pos ~= self:GetPos() and TimeDistortionsPresent(dest_pos, 1000)
	then
		return true
	end
end)