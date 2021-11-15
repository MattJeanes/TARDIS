ENT:AddHook("Initialize","handbrake-init", function(self)
	self:SetData("handbrake", false, true)
end)

if CLIENT then return end

function ENT:ToggleHandbrake()
	return self:SetHandbrake(not self:GetData("handbrake"))
end
function ENT:SetHandbrake(on)
	if (self:CallHook("CanToggleHandbrake") == false
		or self.interior:CallHook("CanToggleHandbrake")) == false
	then
		return false
	end
	self:SetData("handbrake", on, true)
	self:CallHook("HandbrakeToggled", on)
	if self.interior then
		self.interior:CallHook("HandbrakeToggled", on)
	end
	return true
end

ENT:AddHook("FailDemat", "handbrake", function(self, force)
	if self:GetData("handbrake") and force ~= true then
		return true
	end
end)

ENT:AddHook("HandbrakeToggled", "vortex", function(self, force)
	if self:GetData("handbrake") then
		if self:GetData("teleport") or self:GetData("vortex") then
			self:InterruptTeleport()
		end
	end
end)
