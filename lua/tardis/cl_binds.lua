-- Binds

function TARDIS:ChangeKeyBind(id,data)
	local frame = vgui.Create("DFrame")
	frame:SetSkin("TARDIS")
	frame:SetTitle("TARDIS Interface")
	frame:SetSize(250,125)
	frame:SetDraggable(false)
	frame:SetBackgroundBlur(true)
	frame:SetDrawOnTop(true)
	frame:Center()
	frame:MakePopup()
	
	local text = vgui.Create("DLabel",frame)
	text:SetAutoStretchVertical(true)
	text:SetMultiline(true)
	text:SetWrap(true)
	text:SetText((data.section and "["..data.section.."]" or "").." "..(data.name or id)..(data.desc and ": "..data.desc or ""))
	text:SetWide(frame:GetWide()-20)
	text:SetPos(10,30)
	text:SetTextColor( color_white )
	
	local keybutton = vgui.Create("DButton", frame)
	keybutton:SetSize(frame:GetWide()*0.6-30, 40)
	keybutton:SetPos((frame:GetWide()*0.5)-(keybutton:GetWide()*0.5),frame:GetTall()-keybutton:GetTall()-10)
	keybutton.key=TARDIS:GetBindKey(id)
	keybutton.Update = function(s)
		s:SetText("Key: "..(TARDIS:GetKeyName(s.key) or "Invalid"))
	end
	keybutton.DoClick = function(s)
		s.keytrap=true
		input.StartKeyTrapping()
		s:SetText("[Press any key]")
	end
	keybutton.Think = function(s)
		if s.keytrap then
			local key=input.CheckKeyTrapping()
			if key then
				s.key=key
				s:Update()
			end
		end
	end
	keybutton:Update()
		
	local button = vgui.Create("DButton",frame)
	button:SetText("Save")
	button:SetSize(frame:GetWide()*0.2, 40)
	button:SetPos(10,frame:GetTall()-button:GetTall()-10)
	button.DoClick = function() TARDIS:SetKeyBind(id,keybutton.key) frame:Close() end
	
	local reset = vgui.Create("DButton",frame)
	reset:SetText("Reset")
	reset:SetSize(frame:GetWide()*0.2, 40)
	reset:SetPos(frame:GetWide()-reset:GetWide()-10,frame:GetTall()-reset:GetTall()-10)
	reset.DoClick = function() keybutton.key=TARDIS:GetBind(id).key keybutton:Update() end
end

TARDIS:AddGUISetting("Binds", function(self,frame,screen)
	local keybinds={}
	local sections={}
	for k,v in pairs(TARDIS:GetBinds()) do
		table.insert(keybinds,{k,v})
		if v.section and not table.HasValue(sections,v.section) then
			table.insert(sections,v.section)
		end
	end
	table.SortByMember(keybinds,1,true)
	table.SortByMember(sections,1,true)
	
	for k,v in ipairs(sections) do
		local f=vgui.Create("DPanel",frame)
		f.name=v
		f:SetVisible(false)
		f:SetSize(frame:GetSize())
		self:LoadButtons(screen,f,function(frame)
			local buttons={}
			for a,b in ipairs(keybinds) do
				if b[2].section==v then
					local id,data=b[1],b[2]
					local button = vgui.Create("DButton",frame)
					button:SetText(data.name or id)
					button:SetFont("TARDIS-Default")
					button.DoClick = function()
						self:ChangeKeyBind(id,data)
					end
					table.insert(buttons,button)
				end
			end
			return buttons
		end)
		sections[k]=f
	end
	
	local mainf=vgui.Create("DPanel",frame)
	mainf:SetSize(frame:GetSize())
	
	self:LoadButtons(screen,mainf,function(frame)
		local buttons={}
		for k,v in ipairs(sections) do
			local button = vgui.Create("DButton",frame)
			button:SetText(v.name)
			button:SetFont("TARDIS-Default")
			button.DoClick = function()
				self:PushScreen(v.name,screen,frame,v)
			end
			table.insert(buttons,button)
		end
		for k,v in ipairs(keybinds) do
			local id,data=v[1],v[2]
			if not data.section then
				local button = vgui.Create("DButton",frame)
				button:SetText(data.name or id)
				button:SetFont("TARDIS-Default")
				button.DoClick = function()
					self:ChangeKeyBind(id,data)
				end
				table.insert(buttons,button)
			end
		end
		return buttons
	end)
end)