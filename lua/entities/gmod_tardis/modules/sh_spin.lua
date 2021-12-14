-- Spin

TARDIS:AddSetting({
	id="opened-door-no-spin",
	name="Stop spinning with opened door",
	desc="Should the TARDIS stop spinning when doors are opened in flight?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=true
})

if CLIENT then return end


ENT:AddHook("Initialize", "spin", function(self)
	self:SetData("spindir", -1)
	self:SetData("spindir_prev", 0)
end)

function ENT:ToggleSpin()
	local current = self:GetData("spindir", -1)
	local prev = self:GetData("spindir_prev", 0)

	self:SetData("spindir_prev", current)
	self:SetData("spindir", prev)
end

function ENT:CycleSpinDir()
	local current = self:GetData("spindir", -1)
	local prev = self:GetData("spindir_prev", 0)

	self:SetData("spindir_prev", current)
	self:SetData("spindir", -prev)
end

function ENT:SwitchSpinDir()
	local current = self:GetData("spindir", -1)
	local prev = self:GetData("spindir_prev", 0)

	self:SetData("spindir_prev", -prev)
	self:SetData("spindir", -current)
end

function ENT:GetSpinDir()
	return self:GetData("spindir", -1)
end

function ENT:SetSpinDir(dir)
	return self:SetData("spindir", dir)
end

function ENT:GetSpinDirText(show_next)
	local current = self:GetData("spindir", -1)
	if show_next == true then
		current = self:GetData("spindir_prev", 0)
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
	if TARDIS:GetSetting("opened-door-no-spin", false, self:GetCreator()) then
		local current = self:GetData("spindir", -1)
		local before = self:GetData("spindir_before_door", nil)

		if open and self:GetSpinDir() ~= 0 then
			self:SetData("spindir_before_door", current)
			self:SetData("spindir_prev", current)
			self:SetData("spindir", 0)
		elseif not open and self:GetSpinDir() == 0 and before ~= nil then
			self:SetData("spindir_before_door", nil)
			self:SetData("spindir_prev", current)
			self:SetData("spindir", before)
		end
	end
end)