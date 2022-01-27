-- Fast remat / vortex flight related functions

if CLIENT then return end

ENT:AddHook("StopDemat", "teleport-fast", function(self)
	if self:GetData("demat-fast",false) then
		timer.Simple(0.3, function()
			if not IsValid(self) then return end
			self:Mat()
		end)
	end
end)

function ENT:ToggleFastRemat()
	if self:CallHook("CanToggleFastRemat") ~= false then
		local on = not self:GetData("demat-fast",false)
		return self:SetFastRemat(on)
	end
end

function ENT:SetFastRemat(on)
	self:SetData("demat-fast",on,true)
	return true
end

ENT:AddHook("CanToggleFastRemat", "vortex", function(self)
	if self:GetData("vortex",false) then
		return false
	end
end)

function ENT:FastReturn(callback)
	if self:CallHook("CanDemat") ~= false and self:GetData("fastreturn-pos") then
		self:SetData("demat-fast-prev", self:GetData("demat-fast", false));
		self:SetFastRemat(true)
		self:SetData("fastreturn",true)
		self:Demat(self:GetData("fastreturn-pos"),self:GetData("fastreturn-ang"))
		if callback then callback(true) end
	else
		if callback then callback(false) end
	end
end

function ENT:AutoDemat(pos, ang, callback)
	if self:CallHook("CanDemat", false) ~= false then
		self:Demat(pos, ang, callback)
	elseif self:CallHook("CanDemat", true)  ~= false then
		self:ForceDemat(pos, ang, callback)
	else
		if callback then callback(false) end
	end
end
