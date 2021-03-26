-- Security System (Isomorphic)

TARDIS:AddSetting({
	id="security",
	name="Isomorphic Security",
	value=false,
	type="bool",
	networked=true,
	option=true,
	desc="Whether or not people other than you can use your TARDIS' controls."
})

TARDIS:AddControl({
	id = "isomorphic",
	int_func=function(self,ply)
		if ply ~= self:GetCreator() then
			TARDIS:ErrorMessage(ply, "This is not your TARDIS")
			return
		end
		if self:ToggleSecurity() then
			TARDIS:StatusMessage(ply, "Isomorphic security", self:GetData("security"))
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle isomorphic security")
		end
	end,
	serveronly = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {2, 1},
		text = "Isomorphic Security",
		pressed_state_from_interior = true,
		pressed_state_data = "security",
		order = 14,
	},
	tip_text = "Isomorphic Security System",
})

function ENT:GetSecurity()
	return self:GetData("security", false)
end

if SERVER then
	function ENT:SetSecurity(on)
		return self:SetData("security", on, true)
	end

	function ENT:ToggleSecurity()
		self:SetSecurity(not self:GetSecurity())
		return true
	end
end

-- Hooks

ENT:AddHook("Initialize","security", function(self)
	self:SetData("security", TARDIS:GetSetting("security",false,self:GetCreator()), true)
end)

ENT:AddHook("CanUsePart","security",function(self,part,ply)
	if self:GetSecurity() and (ply~=self:GetCreator()) then
		if part.BypassIsomorphic then return end
        TARDIS:Message(ply, "This TARDIS uses Isomorphic Security. You may not use any controls.")
		return false,false
	end
end)
