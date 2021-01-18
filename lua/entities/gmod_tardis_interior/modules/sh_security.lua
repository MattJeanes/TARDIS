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

--Hooks
ENT:AddHook("CanUsePart","security",function(self,part,ply)
	if TARDIS:GetSetting("security",false,self:GetCreator())==true and (ply~=self:GetCreator()) then
		if part.ID == "door" then return end
		ply:ChatPrint("This TARDIS uses Isomorphic Security. You may not use any controls.")
		return false,false
	end
end)