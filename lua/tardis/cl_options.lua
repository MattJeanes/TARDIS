-- Options

local value

hook.Add("TARDIS-UpdateCustomOption", "custom_option_value_change", function(newData)
	value = newData
end)

function TARDIS:ChangeOption(id,data)
	local frame = vgui.Create("DFrame")
	frame:SetSkin("TARDIS")
	frame:SetTitle("TARDIS Interface")
	frame:SetSize(250,150)
	frame:SetDraggable(false)
	frame:SetBackgroundBlur(true)
	
	local text = vgui.Create("DLabel",frame)
	text:SetAutoStretchVertical(true)
	text:SetMultiline(true)
	text:SetWrap(true)
	text:SetText((data.section and "["..data.section.."]" or "").." "..(data.name or id)..(data.desc and ": "..data.desc or ""))
	text:SetWide(frame:GetWide()-20)
	text:SetPos(10,30)
	text:SetTextColor(color_white)
	
	value=TARDIS:GetSetting(id,data.value,data.networked and LocalPlayer() or nil)
	
	local update
	if data.type=="number" then
		local textentry,option
		function update(v)
			if not v then
				v = 0
			end
			option:SetSlideX((v)/(data.max-data.min))
			textentry:SetText(v)
		end
		textentry = vgui.Create("DTextEntry",frame)
		textentry:SetWide(frame:GetWide()*0.6-50)
		textentry:SetPos((frame:GetWide()*0.5)-(textentry:GetWide()*0.5),frame:GetTall()-textentry:GetTall()-16-15)
		textentry:SetDrawBackground(true)
		textentry:SetNumeric(true)
		textentry.OnEnter = function(s,v)
			value=math.Clamp(tonumber(textentry:GetText()),data.min,data.max)
			textentry:SetText(value)
		end
		
		option = vgui.Create("DSlider",frame)
		option:SetLockY(0.5)
		option:SetSize(frame:GetWide()*0.6-50, 16)
		option:SetPos((frame:GetWide()*0.5)-(option:GetWide()*0.5),frame:GetTall()-option:GetTall()-10)
		option:SetTrapInside(true)
		option:SetHeight(16)
		option:SetNotches(option:GetWide()/4)
		option.TranslateValues = function(s,x,y)
			value=math.Round(data.min+(x*(data.max-data.min)))
			textentry:SetText(value)
			return x,y
		end
		Derma_Hook(option,"Paint","Paint","NumSlider")
	elseif data.type=="bool" then
		local checkbox=vgui.Create("DCheckBox",frame)
		checkbox:SetSize(32,32)
		checkbox:SetPos((frame:GetWide()*0.5)-(checkbox:GetWide()*0.5),frame:GetTall()-checkbox:GetTall()-15)
		checkbox.OnChange = function(s,v) value=v end
		function update(v)
			checkbox:SetChecked(v)
		end
	elseif data.type=="color" then
		frame:SetTall(frame:GetTall()+100)
		local mixer = vgui.Create("DColorMixer",frame)
		mixer:SetSize(frame:GetWide()-20,100)
		mixer:SetPos((frame:GetWide()*0.5)-(mixer:GetWide()*0.5),frame:GetTall()-mixer:GetTall()-60)
		mixer:SetPalette(false)
		mixer:SetAlphaBar(false)
		mixer:SetWangs(true)
		mixer.ValueChanged = function(s,v) value=v end
		function update(v)
			if v then
				mixer:SetColor(v)
			else
				mixer:SetColor(Color(0,0,0))
			end
		end
	elseif data.type == "custom" then
		--print("Custom button has been called!")
		local customUpdate = hook.Run("TARDIS-CustomOption", frame, value)
		
		function update(v)
			customUpdate(v)
		end
	end
	
	update(value)
	
	local button = vgui.Create("DButton",frame)
	button:SetText("Save")
	button:SetSize(frame:GetWide()*0.2, 40)
	button:SetPos(10,frame:GetTall()-button:GetTall()-10)
	button.DoClick = function() TARDIS:SetSetting(id,value,data.networked) frame:Close() end
	
	local reset = vgui.Create("DButton",frame)
	reset:SetText("Reset")
	reset:SetSize(frame:GetWide()*0.2, 40)
	reset:SetPos(frame:GetWide()-reset:GetWide()-10,frame:GetTall()-reset:GetTall()-10)
	reset.DoClick = function() update(data.value) value=data.value end
	
	frame:Center()
	frame:MakePopup()
end

TARDIS:AddGUISetting("Options", function(self,frame,screen)
	local options={}
	local sections={}
	for k,v in pairs(TARDIS:GetSettingsData()) do
		if v.option then
			table.insert(options,{v.name,v.id,v})
			if v.section and not table.HasValue(sections,v.section) then
				table.insert(sections,v.section)
			end
		end
	end
	table.SortByMember(options,1,true)
	table.SortByMember(sections,1,true)
	
	for k,v in ipairs(sections) do
		local f=vgui.Create("DPanel",frame)
		f.name=v
		f:SetVisible(false)
		f:SetSize(frame:GetSize())
		self:LoadButtons(screen,f,function(frame)
			local buttons={}
			for a,b in ipairs(options) do
				local name,id,data=b[1],b[2],b[3]
				if data.section==v then
					local button = vgui.Create("DButton",frame)
					button:SetText(name or id)
					button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
					button.DoClick = function()
						self:ChangeOption(id,data)
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
			button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
			button.DoClick = function()
				self:PushScreen(v.name,screen,frame,v)
			end
			table.insert(buttons,button)
		end
		for k,v in ipairs(options) do
			local name,id,data=v[1],v[2],v[3]
			if not data.section then
				local button = vgui.Create("DButton",frame)
				button:SetText(name or id)
				button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
				button.DoClick = function()
					self:ChangeOption(id,data)
				end
				table.insert(buttons,button)
			end
		end
		return buttons
	end)
end)