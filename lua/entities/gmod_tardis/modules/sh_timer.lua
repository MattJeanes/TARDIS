local timers = {}

function ENT:Timer(id, delay, action)
	timers[id] = { CurTime() + delay, action }
end

function ENT:CancelTimer(id)
	timers[id] = nil
end

function ENT:GetTimers()
	return timers
end

function ENT:GetTimer(id)
	return timers[id]
end

ENT:AddHook("Think", "timers", function(self)
	for k,v in pairs(timers)
	do
		if CurTime() > v[1] then
			self:CancelTimer(k)
			local func = v[2]
			func()
		end
	end
end)

