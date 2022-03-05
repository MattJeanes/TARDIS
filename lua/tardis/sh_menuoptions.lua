if CLIENT then
    hook.Add("PopulateToolMenu", "TARDIS2-PopulateToolMenu", function()

        -- Options
        local options={}
        local sections={}
        for k,v in pairs(TARDIS:GetSettingsData()) do
            if v.option then
                table.insert(options,{v.id,v})
                if v.section and not table.HasValue(sections,v.section) then
                    table.insert(sections,v.section)
                end
            end
        end
        table.SortByMember(options,1,true)
        table.SortByMember(sections,1,true)

        for k,v in ipairs(sections) do
            spawnmenu.AddToolMenuOption("Options", "TARDIS", "TARDIS2_Options_" .. v, v, "", "", function(panel)
                for a,b in ipairs(options) do
                    local id,data=b[1],b[2]
                    if data.section == v then
                        local option_changer = TARDIS:CreateOptionInterface(id, data)
                        panel:AddItem(option_changer)
                    end
                end
            end)
        end

        spawnmenu.AddToolMenuOption("Options", "TARDIS", "TARDIS2_Options_Other", "Other", "", "", function(panel)
            for a,b in ipairs(options) do
                local id,data=b[1],b[2]
                if not data.section then
                    local option_changer = TARDIS:CreateOptionInterface(id, data)
                    panel:AddItem(option_changer)
                end
            end
        end)


        -- Binds
        spawnmenu.AddToolMenuOption("Options", "TARDIS", "TARDIS2_Binds", "Binds", "", "", function(panel)
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
                local category = vgui.Create("DForm")
                panel:AddItem(category)

                category:SetLabel(v)
                category:SetExpanded(false)

                for a,b in ipairs(keybinds) do
                    local id,data=b[1],b[2]
                    if data.section == v then
                        local keybind_changer = TARDIS:CreateBindOptionInterface(id, data)
                        category:AddItem(keybind_changer)
                    end
                end
            end

            local other_category = vgui.Create("DForm")
            panel:AddItem(other_category)

            other_category:SetLabel("Other")
            other_category:SetExpanded(false)

            for a,b in ipairs(keybinds) do
                local id,data=b[1],b[2]
                if not data.section then
                    local keybind_changer = TARDIS:CreateBindOptionInterface(id, data)
                    other_category:AddItem(keybind_changer)
                end
            end
        end)

        -- Reset all
        spawnmenu.AddToolMenuOption("Options", "TARDIS", "TARDIS2_Reset_Settings", "Reset Settings", "", "", function(panel)
            local button = vgui.Create("DButton")
            button:SetText("Reset clientside settings")
            button.DoClick = function(button)
                Derma_Query(
                    "Reset all clientside settings? This cannot be undone.",
                    "TARDIS Interface",
                    "OK", function()
                        TARDIS:ResetSettings()
                        TARDIS:Message(LocalPlayer(), "TARDIS clientside settings have been reset. You may need to respawn the TARDIS for all changes to apply.")
                    end,
                    "Cancel", nil
                ):SetSkin("TARDIS")
            end
            panel:AddItem(button)
        end)


        spawnmenu.AddToolMenuOption("Options", "TARDIS", "TARDIS2_Options_old", "Options (old)", "", "", function(panel)
            panel:ClearControls()
            -- Do menu things here

            local DLabel = vgui.Create( "DLabel" )
            DLabel:SetText("The TARDIS Interface is available at any time using the button below:")
            panel:AddItem(DLabel)

            local button = vgui.Create("DButton")
            button:SetText("Open TARDIS Interface")
            button.DoClick = function(self)
                TARDIS:HUDScreen()
            end
            panel:AddItem(button)

            local htoggle = vgui.Create("DCheckBoxLabel")
            htoggle:SetText("Enable Health and Damage")
            htoggle:SetValue(TARDIS:GetSetting("health-enabled"))
            function htoggle:OnChange(val)
                net.Start("TARDIS-DamageCvar")
                    net.WriteBool(val)
                net.SendToServer()
            end
            panel:AddItem(htoggle)

            local cstoggle = vgui.Create("DCheckBoxLabel")
            cstoggle:SetText("Enable Control Sequences")
            cstoggle:SetValue(TARDIS:GetSetting("csequences-enabled", false, LocalPlayer()))
            function cstoggle:OnChange(val)
                TARDIS:SetSetting("csequences-enabled", val, true)
            end
            panel:AddItem(cstoggle)

            local DLabel2 = vgui.Create( "DLabel" )
            DLabel2:SetText("TARDIS Interior:")
            panel:AddItem(DLabel2)

            local tips_toggle = vgui.Create("DCheckBoxLabel")
            tips_toggle:SetText("Enable tips")
            tips_toggle:SetValue(TARDIS:GetSetting("tips"))
            function tips_toggle:OnChange(val)
                TARDIS:SetSetting("tips", val)
            end
            panel:AddItem(tips_toggle)

            local DLabelTips = vgui.Create( "DLabel" )
            DLabelTips:SetText("Tips style:")
            panel:AddItem(DLabelTips)

            local tips_style = vgui.Create("DComboBox")
            tips_style:SetText("Tips style")
            for k,v in pairs(TARDIS:GetTipStyles()) do
                v.OptionID=tips_style:AddChoice(v.style_name,v.style_id)
            end
            local selected_tip_style=TARDIS:GetSetting("tips_style","default")
            for k,v in pairs(TARDIS:GetTipStyles()) do
                if selected_tip_style==v.style_id then
                    tips_style:ChooseOption(v.OptionID)
                    tips_style:SetText(v.style_name)
                end
            end
            tips_style.OnSelect = function(panel,index,value,data)
                TARDIS:SetSetting("tips_style", data)
            end
            panel:AddItem(tips_style)

            local visgui_toggle = vgui.Create("DCheckBoxLabel")
            visgui_toggle:SetText("Enable new visual GUI")
            visgui_toggle:SetValue(TARDIS:GetSetting("visgui_enabled"))
            function visgui_toggle:OnChange(val)
                TARDIS:SetSetting("visgui_enabled", val)
            end
            panel:AddItem(visgui_toggle)

            local visgui_big_toggle = vgui.Create("DCheckBoxLabel")
            visgui_big_toggle:SetText("Visual GUI big popup")
            visgui_big_toggle:SetValue(TARDIS:GetSetting("visgui_bigpopup"))
            function visgui_big_toggle:OnChange(val)
                TARDIS:SetSetting("visgui_bigpopup", val)
            end
            panel:AddItem(visgui_big_toggle)

            local DLabel3 = vgui.Create( "DLabel" )
            DLabel3:SetText("Number of visual GUI button rows on the screen:")
            panel:AddItem(DLabel3)

            local visgui_numrows_override = vgui.Create("DCheckBoxLabel")
            visgui_numrows_override:SetText("Override interior settings")
            visgui_numrows_override:SetValue(TARDIS:GetSetting("visgui_override_numrows"))
            function visgui_numrows_override:OnChange(val)
                TARDIS:SetSetting("visgui_override_numrows", val)
            end
            panel:AddItem(visgui_numrows_override)

            local visgui_screen_numrows = vgui.Create("DNumSlider")
            visgui_screen_numrows:SetMinMax(2, 10)
            visgui_screen_numrows:SetDecimals(0)
            visgui_screen_numrows:SetValue(TARDIS:GetSetting("visgui_screen_numrows"))
            function visgui_screen_numrows:OnValueChanged(val)
                val = math.floor(val)
                visgui_screen_numrows:SetValue(val)
                TARDIS:SetSetting("visgui_screen_numrows", val)
            end
            panel:AddItem(visgui_screen_numrows)

            local DLabel4 = vgui.Create( "DLabel" )
            DLabel4:SetText("Number of visual GUI button rows in the popup:")
            panel:AddItem(DLabel4)
            local visgui_popup_numrows = vgui.Create("DNumSlider")
            visgui_popup_numrows:SetMinMax(2, 10)
            visgui_popup_numrows:SetDecimals(0)
            visgui_popup_numrows:SetValue(TARDIS:GetSetting("visgui_popup_numrows"))
            function visgui_popup_numrows:OnValueChanged(val)
                val = math.floor(val)
                visgui_popup_numrows:SetValue(val)
                TARDIS:SetSetting("visgui_popup_numrows", val)
            end
            panel:AddItem(visgui_popup_numrows)

            local DLabel4 = vgui.Create( "DLabel" )
            DLabel4:SetText("TARDIS Visual GUI Theme:")
            panel:AddItem(DLabel4)

            local visgui_theme = vgui.Create("DComboBox")
            visgui_theme:SetText("Visual GUI Theme")
            for k,v in pairs(TARDIS:GetGUIThemes()) do
                v.OptionID = visgui_theme:AddChoice(v.name, v.id)
            end
            local selectedtheme=TARDIS:GetSetting("visgui_theme", "default")
            for k,theme in pairs(TARDIS:GetGUIThemes()) do
                if selectedtheme == theme.id then
                    visgui_theme:ChooseOption(theme.OptionID)
                    visgui_theme:SetText(theme.name)
                end
            end
            visgui_theme.OnSelect = function(panel, index, value, data)
                TARDIS:SetSetting("visgui_theme", data)
                TARDIS:Message(LocalPlayer(), "TARDIS visual GUI theme changed to "..value)
            end
            panel:AddItem(visgui_theme)

        end)
    end)
else
    util.AddNetworkString("TARDIS-DamageCvar")

    net.Receive("TARDIS-DamageCvar", function(len, ply)
        if ply:IsAdmin() or ply:IsSuperAdmin() then
            local val = net.ReadBool()
            RunConsoleCommand( "tardis2_damage", tostring(val) )
        end
    end)
end

-- cvars can either be a int, float, bool or string
