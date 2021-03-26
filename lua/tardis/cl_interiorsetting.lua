-- Interior

TARDIS:AddSetting({
	id="interior",
	name="Interior",
	value="default",
	networked=true
})

TARDIS:AddGUISetting("Interior", function(self,frame,screen)
	local interiors={}
	for k,v in pairs(TARDIS:GetInteriors()) do
		table.insert(interiors,{v.Name,v.ID,v.Base})
	end
	table.SortByMember(interiors,1,true)
	self:LoadButtons(screen,frame,function(frame)
		local buttons={}
		for k,v in ipairs(interiors) do
			if v[3] ~= true then
				local button = vgui.Create("DButton",frame)
				button:SetText(v[1])
				button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
				button.DoClick = function()
					TARDIS:SetSetting("interior",v[2],true)
                    TARDIS:Message(LocalPlayer(), "TARDIS interior changed. Spawn a new TARDIS for changes to apply.")
				end
				table.insert(buttons,button)
			end
		end
		return buttons
	end)
end)