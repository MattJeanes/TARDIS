-- Support for time distortion generator by parar020100 and JEREDEK

local function TimeDistortionsPresent(pos, radius)
	for i,v in ipairs(ents.FindInSphere(pos, radius)) do
		if v:GetClass() == "gmod_time_distortion_generator" and v:GetEnabled() then
			return true
		end
	end
	return false
end

ENT:AddHook("FailDemat", "time_distortions", function(self, force)

	if force then return end

	if TimeDistortionsPresent(self:GetPos(), 500) or
		TimeDistortionsPresent(self.interior:GetPos(), self.metadata.Interior.ExitDistance)
	then
		return true
	end

end)


ENT:AddHook("CanMat", "time_distortions", function(self)
	if TimeDistortionsPresent(self.interior:GetPos(), self.metadata.Interior.ExitDistance)
	then
		return false
	end
end)