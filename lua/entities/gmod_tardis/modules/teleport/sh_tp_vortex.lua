-- Fast remat / vortex flight related functions

TARDIS:AddControl({ id = "vortex_flight",
	ext_func=function(self,ply)
		if self:ToggleFastRemat() then
			TARDIS:StatusMessage(ply, "Vortex flight", self:GetData("demat-fast"), "disabled", "enabled")
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle vortex flight")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {1, 2},
		text = "Vortex Flight",
		pressed_state_from_interior = false,
		pressed_state_data = "demat-fast",
		order = 8,
	},
	tip_text = "Vortex Flight Toggler",
})

if SERVER then

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

end