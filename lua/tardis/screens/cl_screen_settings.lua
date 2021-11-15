-- Settings

TARDIS:AddScreen("Settings", {id="settings", order=20}, function(self,ext,int,frame,screen)	
	local settings={}
	for k,v in pairs(self.GUISettings) do
		local f=vgui.Create("DPanel",frame)
		f:SetVisible(false)
		f:SetSize(frame:GetSize())
		v(self,f,screen)
		table.insert(settings,{k,f})
	end
	table.SortByMember(settings,1,true)

	local mainf=vgui.Create("DPanel",frame)
	mainf:SetSize(frame:GetSize())

	self:LoadButtons(screen,mainf,function(frame)
		local buttons={}
		for k,v in ipairs(settings) do
			local button = vgui.Create("DButton",frame)
			button:SetText(v[1])
			button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
			button.DoClick = function()
				self:PushScreen(v[1],screen,frame,v[2])
			end
			table.insert(buttons,button)
		end
		return buttons
	end)
end)