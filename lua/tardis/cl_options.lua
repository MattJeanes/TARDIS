-- Options

function TARDIS:CreateOptionInterface(id, data)

    local text = data.name or id
    local tooltip = data.desc or ""
    if data.value ~= nil then
        tooltip = tooltip .. "\n\nDefault: " .. tostring(data.value)
    end

    local elem
    local elem2 = nil

    local setting = TARDIS:GetSetting(id)

    if data.type == "bool" then
        elem = vgui.Create("DCheckBoxLabel")
        elem:SetChecked(setting)
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

    elseif data.type == "number" or data.type == "integer" then
        elem = vgui.Create("DNumSlider")
        elem:SetMinMax(data.min, data.max)

        if data.type == "integer" then
            elem:SetDecimals(0)
        end
        elem:SetValue(setting)
        elem:GetTextArea():SetText(tostring(setting))
        elem.OnValueChanged = function(self, val)
            self.lastchange = CurTime()
            self.lastchange_val = val
        end
        elem.Think = function(self)
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

    elseif data.type=="color" then
        elem = vgui.Create("DForm")
        elem:SetLabel(text)
        elem:SetExpanded(true)

        local mixer = vgui.Create("DColorMixer")
        mixer:SetText(text)
        mixer:SetPalette(false)
        mixer:SetAlphaBar(false)
        mixer:SetWangs(true)
        mixer:SetColor(setting)
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

        elem:AddItem(mixer)

        local spacer = vgui.Create("DPanel")
        spacer:SetTall(2)
        elem:AddItem(spacer)

    elseif data.type=="list" then
        elem = vgui.Create("DLabel")

        elem2 = vgui.Create("DComboBox")

        if data.get_values_func ~= nil then
            for k,v in pairs(data.get_values_func()) do
                elem2:AddChoice(v[1], v[2])
            end
        end

        elem2:SetText(elem2:GetOptionTextByData(setting))
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

    else
        elem = vgui.Create("DLabel")
    end

    if elem.SetText then elem:SetText(text) end
    if elem.SetDark then elem:SetDark(true) end

    elem:SetTooltip(tooltip)
    if elem2 then
        elem2:SetTooltip(tooltip)
    end

    return elem, elem2
end
