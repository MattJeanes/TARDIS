ENT:AddHook("Initialize", "timers", function(self)
	self.timers = {}
end)

function ENT:Timer(id, delay, action)
	self.timers[id] = { CurTime() + delay, action }
end

function ENT:CancelTimer(id)
	self.timers[id] = nil
end

function ENT:GetTimers()
	return self.timers
end

function ENT:GetTimer(id)
	return self.timers[id]
end

ENT:AddHook("Think", "timers", function(self)
	for k,v in pairs(self.timers)
	do
		if CurTime() > v[1] then
			self:CancelTimer(k)
			local func = v[2]
			func()
		end
	end
end)

