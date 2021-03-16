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
		
		ply:ChatPrint("This TARDIS uses Isomorphic Security. You may not use any controls.")
		return false,false
	end
end)
