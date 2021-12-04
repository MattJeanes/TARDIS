-- Spin

ENT:AddHook("Initialize", "spin", function(self)
	self:SetSpinDir(-1)
end)

function ENT:ToggleSpin()
	local current = self:GetData("spindir", -1)
	if current == 0 then
		local prev = self:GetData("spindir_old", -1)
		self:SetData("spindir", prev)
	else
		self:SetData("spindir_old", current)
		self:SetData("spindir", 0)
	end
end

function ENT:CycleSpinDir()
	local current = self:GetData("spindir", -1)
	if current == -1 then
		self:SetData("spindir", 0)
	elseif current == 0 then
		self:SetData("spindir", 1)
	elseif current == 1 then
		self:SetData("spindir", -1)
	end
end

function ENT:SwitchSpinDir()
	local current = self:GetData("spindir", -1)
	if current == 0 then
		local prev = self:GetData("spindir_old", -1)
		if prev == -1 then
			self:SetData("spindir_old", 1)
		elseif prev == 1 then
			self:SetData("spindir_old", -1)
		end
	elseif current == -1 then
		self:SetData("spindir", 1)
	elseif current == 1 then
		self:SetData("spindir", -1)
	end
end

function ENT:GetSpinDir()
	return self:GetData("spindir", -1)
end

function ENT:SetSpinDir(dir)
	return self:SetData("spindir", dir)
end

function ENT:GetSpinDirText(old)
	local current = self:GetData("spindir", -1)
	if old == true then
		current = self:GetData("spindir_old", -1)
	end

	if current == -1 then
		return "anti-clockwise"
	elseif current == 0 then
		return "none"
	elseif current == 1 then
		return "clockwise"
	end
end

ENT:AddHook("ToggleDoor", "spin-dir", function(self,open)
	if open and self:GetSpinDir() ~= 0 then
		local current = self:GetData("spindir", -1)
		self:SetData("spindir_before_door", current)
		self:SetData("spindir", 0)
	elseif not open and self:GetSpinDir() == 0 then
		local prev = self:GetData("spindir_before_door", nil)
		if prev ~= nil then
			self:SetData("spindir_before_door", nil)
			self:SetData("spindir", prev)
		end
	end
end)