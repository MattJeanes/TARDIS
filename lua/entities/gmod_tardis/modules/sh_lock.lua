-- Lock

function ENT:ToggleLocked(callback)
	self:SetLocked(not self:Locked(),callback)
end

function ENT:SetLocked(locked,callback)
	if locked then
		self:SetData("locking",true,true)
		self:CloseDoor(function(state)
			if state then
				if callback then callback(false) end
			end
			self:SetData("locked",true,true)
			self:SetData("locking",false,true)
			if callback then callback(true) end
		end)
	else
		self:SetData("locked",false,true)
		if callback then callback(true) end
	end
end

function ENT:Locked()
	return self:GetData("locked",false)
end

function ENT:Locking()
	return self:GetData("locking",false)
end

ENT:AddHook("CanPlayerEnter","lock",function(self,ply)
	if self:Locked() then
		return false
	end
end)

ENT:AddHook("CanToggleDoor","lock",function(self,state)
	if (not state) and self:Locked() then
		return false
	end
end)