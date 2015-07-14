-- Binds

ENT:AddGUISetting("Binds", function(self,frame)
	local keybinds={}
	for k,v in pairs(self:GetKeyBinds()) do
		table.insert(keybinds,{k,v})
	end
	table.SortByMember(keybinds,1,true)
	self:LoadButtons(frame,function(frame)
		local buttons={}
		for k,v in ipairs(keybinds) do
			local button = vgui.Create("DButton",frame)
			button:SetText(v[1])
			button:SetFont("TARDIS-Default")
			button.DoClick = function()
				LocalPlayer():ChatPrint(self:GetKeyName(v[2]))
			end
			table.insert(buttons,button)
		end
		return buttons
	end)
end)