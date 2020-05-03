
hook.Add("EntityTakeDamage", "dodo_tardis_hads", function(tard)
	if tard:GetData("hads") == true then
		if tard:GetClass() == "gmod_tardis" then
			timer.Simple(0.25, function()
				tard:Demat()
				local owner = tard:GetCreator()
				local opos = owner:GetPos()
				owner:SendLua("chat.AddText(\"Your TARDIS is under attack! It has dematerialised and is now on its way to you for safety!\")")
				timer.Simple(15, function()
					tard:SetDestination(opos)
					tard:Mat()
				end)
			end)
		end
	end
end)
