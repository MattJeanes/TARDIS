--Security System (Isomorphic)

TARDIS:AddSetting({
	id="security",
	name="Isomorphic Security",
	value=false,
	type="bool",
	networked=true,
	option=true,
	desc="Whether or not people other than you can use your TARDIS' controls."
})

if SERVER then
	function ENT:SetSecurity(on)
		return self:SetData("security", on, true)
	end

	function ENT:ToggleSecurity()
		local on = not self:GetData("security", false)
		return self:SetSecurity(on)
	end
end

-- Hooks

ENT:AddHook("Initialize","security", function(self)
	self:SetData("security", TARDIS:GetSetting("security",false,self:GetCreator()), true)
end)

ENT:AddHook("CanUsePart","security",function(self,part,ply)
	if self:GetData("security", false) and (ply~=self:GetCreator()) then
		-- Default to false if not exists. This is to not break any extensions' parts
		if part.BypassIsomorphic then return end
		
		ply:ChatPrint("This TARDIS uses Isomorphic Security. You may not use any controls.")
		return false,false
	end
end)
