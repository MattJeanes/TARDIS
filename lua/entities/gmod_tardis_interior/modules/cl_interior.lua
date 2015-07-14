-- Interior

TARDIS:AddSetting("interior", "default", true)

ENT:AddGUISetting("Interior", function(self,frame)
	local interiors={}
	for k,v in pairs(self:GetInteriors()) do
		table.insert(interiors,{v.Name,v.ID})
	end
	table.SortByMember(interiors,1,true)
	self:LoadButtons(frame,function(frame)
		local buttons={}
		for k,v in ipairs(interiors) do
			local button = vgui.Create("DButton",frame)
			button:SetText(v[1])
			button:SetFont("TARDIS-Default")
			button.DoClick = function()
				TARDIS:SetSetting("interior",v[2],true)
				LocalPlayer():ChatPrint("TARDIS interior changed. Respawn the TARDIS for changes to apply.")
			end
			table.insert(buttons,button)
		end
		return buttons
	end)
end)