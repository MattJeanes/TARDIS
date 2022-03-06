-- Options

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
    
    local value=TARDIS:GetSetting(id,data.value,data.networked and LocalPlayer() or nil)
    
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

function TARDIS:CreateOptionInterface(id, data)

    local text = data.name or id
    local tooltip = data.desc or ""
    if data.value ~= nil then
        tooltip = tooltip .. "\n\nDefault: " .. tostring(data.value)
    end

    local elem

    if data.type == "bool" then
        elem = vgui.Create("DCheckBoxLabel")
        elem:SetValue(TARDIS:GetSetting(id))
        elem.OnChange = function(self, val)
            TARDIS:SetSetting(id, val)
        end
        elem.Think = function(self)
            local setting = TARDIS:GetSetting(id, data.value)
            if setting and setting ~= self:GetChecked() then
                self:SetValue(setting)
            end
        end
    elseif data.type == "number" or data.type == "integer" then
        elem = vgui.Create("DNumSlider")
        elem:SetMinMax(data.min, data.max)
        elem:SetValue(TARDIS:GetSetting(id))

        if data.type == "integer" then
            elem:SetDecimals(0)
        end
        elem.OnValueChanged = function(self, val)
            TARDIS:SetSetting(id, val)
        end
        elem.Think = function(self)
            if not self:IsEditing() then
                local setting = TARDIS:GetSetting(id, data.value)
                if setting and self:GetValue() ~= setting then
                    self:SetValue(setting)
                end
                if setting and self:GetTextArea():GetText() ~= tostring(setting) then
                    self:GetTextArea():SetText(tostring(setting))
                end
            end
        end
    elseif data.type=="color" then
        elem = vgui.Create("DForm")
        elem:SetLabel(text)
        elem:SetExpanded(true)

        local mixer = vgui.Create("DColorMixer")
        mixer:SetText(text)
        mixer:SetPalette(false)
        mixer:SetAlphaBar(false)
        mixer:SetWangs(true)
        mixer.ValueChanged = function(self, val)
            TARDIS:SetSetting(id, val)
        end
        mixer.Think = function(self)
            local setting = TARDIS:GetSetting(id, data.value)
            if setting and self:GetColor() ~= setting then
                self:SetColor(setting)
            end
        end

        elem:AddItem(mixer)

        local spacer = vgui.Create("DPanel")
        spacer:SetTall(2)
        elem:AddItem(spacer)

    elseif data.type=="list" then
        elem = vgui.Create("DComboBox")

        if data.get_values_func ~= nil then
            for k,v in pairs(data.get_values_func()) do
                elem:AddChoice(v[1], v[2])
            end
        end

        elem.OnSelect = function(self, index, value, selected_data)
            TARDIS:SetSetting(id, selected_data)
        end

        elem.Think = function(self)
            local setting = TARDIS:GetSetting(id, data.value)
            local _,selected = self:GetSelected()
            if setting and selected ~= setting then
                self:SetText(self:GetOptionTextByData(setting))
            end
        end
    else
        elem = vgui.Create("DButton")
        elem.DoClick = function()
            TARDIS:ChangeOption(id, data)
        end
    end

    if elem.SetText then elem:SetText(text) end
    if elem.SetDark then elem:SetDark(true) end

    elem:SetTooltip(tooltip)

    return elem
end
