-- Security System (Isomorphic)

TARDIS:AddSetting({
	id="security",
	name="Isomorphic Security on by default",
	value=false,
	type="bool",
	networked=true,
	option=true,
	desc="Whether or not others can use your TARDIS' controls by default."
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
