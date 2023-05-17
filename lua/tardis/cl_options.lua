-- Options

function TARDIS:CreateOptionInterface(id, data)

    local section = "Settings.Sections."..(data.section or "Other")
    local subsection = data.subsection and section .. "." .. data.subsection or section
    local name = subsection .. "." .. (data.name or id)
    local desc = name .. ".Description"
    local text = TARDIS:GetPhrase(name)
    local tooltip = TARDIS:GetPhraseIfExists(desc) or ""
    if data.value ~= nil then
        tooltip = tooltip .. "\n\n".. TARDIS:GetPhrase("Common.Default") .. ": " .. tostring(data.value)
    end

    local elem
    local elem2 = nil

    if data.type == "bool" then
        elem = vgui.Create("DCheckBoxLabel")
        elem.OnChange = function(self, val)
            TARDIS:SetSetting(id, val)
            self.lastchange = CurTime()
        end
        elem.Think = function(self)
            if self.lastchange and CurTime() - self.lastchange > 0.2 then
                self.lastchange = nil
                self:SetChecked(TARDIS:GetSetting(id))
            end
        end

        elem.RefreshVal = function(self)
            local setting = TARDIS:GetSetting(id)
            elem:SetChecked(setting)
        end



    elseif data.type == "number" or data.type == "integer" then
        elem = vgui.Create("DLabel")

        elem2 = vgui.Create("DNumSlider")
        elem2:SetMinMax(data.min, data.max)
        elem2.Label:SetVisible(false)

        elem.Scratch = elem:Add( "DNumberScratch" )
        elem.Scratch:SetImageVisible( false )
        elem.Scratch:Dock( FILL )
        elem.Scratch:SetMin(data.min)
        elem.Scratch:SetMax(data.max)
        elem.Scratch.OnValueChanged = function()
            elem2:ValueChanged(elem.Scratch:GetFloatValue())
        end

        if data.type == "integer" then
            elem2:SetDecimals(0)
            elem.Scratch:SetDecimals(0)
        end

        elem2.OnValueChanged = function(self, val)
            self.lastchange = CurTime()
            self.lastchange_val = val
        end
        elem2.Think = function(self)
            if self.lastchange_val and CurTime() - self.lastchange > 0.1 then
                TARDIS:SetSetting(id, self.lastchange_val)
                self.lastchange_val = nil
            end
            if self.lastchange and CurTime() - self.lastchange > 0.3 then
                self.lastchange = nil
                self:SetValue(TARDIS:GetSetting(id))
                self:GetTextArea():SetText(tostring(TARDIS:GetSetting(id)))
            end
        end

        elem.RefreshVal = function(self)
            local setting = TARDIS:GetSetting(id)
            elem2:SetValue(setting)
            elem.Scratch:SetValue(setting)
            elem2:GetTextArea():SetText(tostring(setting))
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
            self.lastchange = CurTime()
        end
        elem.Think = function(self)
            if self.lastchange and CurTime() - self.lastchange > 0.2 then
                self.lastchange = nil
                self:SetColor(TARDIS:GetSetting(id))
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

        if data.get_values_func ~= nil then
            for k,v in pairs(data.get_values_func()) do
                elem2:AddChoice(TARDIS:GetPhrase(v[1]), v[2])
            end
        end

        tooltip = tooltip .. " (\"" .. elem2:GetOptionTextByData(data.value) .. "\")"

        elem2.OnSelect = function(self, index, value, selected_data)
            TARDIS:SetSetting(id, selected_data)
            self.lastchange = CurTime()
        end
        elem2.Think = function(self)
            if self.lastchange and CurTime() - self.lastchange > 0.2 then
                self.lastchange = nil
                local setting = TARDIS:GetSetting(id)
                self:SetText(self:GetOptionTextByData(setting))
            end
        end

        elem.RefreshVal = function(self)
            local setting = TARDIS:GetSetting(id)
            elem2:SetText(elem2:GetOptionTextByData(setting))
        end



    else
        elem = vgui.Create("DLabel")
    end

    if elem.SetText then elem:SetText(text) end
    if elem.SetDark then elem:SetDark(true) end
    if elem2 and elem2.SetDark then elem2:SetDark(true) end

    elem:SetTooltip(tooltip)
    if elem2 then
        elem2:SetTooltip(tooltip)
    end

    elem:RefreshVal()

    return elem, elem2
end
