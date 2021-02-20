if CLIENT then
	hook.Add("PopulateToolMenu", "TARDIS2-PopulateToolMenu", function()
		spawnmenu.AddToolMenuOption("Options", "Doctor Who", "TARDIS2_Options", "TARDIS Rewrite", "", "", function(panel)
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

			local DLabel2 = vgui.Create( "DLabel" )
			DLabel2:SetText("TARDIS Interior:")
			panel:AddItem(DLabel2)

			local comboBox = vgui.Create("DComboBox")
			comboBox:SetText("Interior")
			for k,v in pairs(TARDIS:GetInteriors()) do
				if v.Base != true then
					v.OptionID=comboBox:AddChoice(v.Name,v.ID)
				end
			end
			local selectedinterior=TARDIS:GetSetting("interior","default")
			for k,v in pairs(TARDIS:GetInteriors()) do
				if selectedinterior==v.ID then
					comboBox:ChooseOption(v.OptionID)
					comboBox:SetText(v.Name)
				end
			end
			comboBox.OnSelect = function(panel,index,value,data)
				TARDIS:SetSetting("interior",data,true)
				LocalPlayer():ChatPrint("TARDIS interior changed. Respawn or repair the TARDIS for changes to apply.")
			end
			panel:AddItem(comboBox)

			local visual_gui_toggle = vgui.Create("DCheckBoxLabel")
			visual_gui_toggle:SetText("Enable new visual GUI")
			visual_gui_toggle:SetValue(TARDIS:GetSetting("visual_gui_enabled"))
			function visual_gui_toggle:OnChange(val)
				TARDIS:SetSetting("visual_gui_enabled", val)
			end
			panel:AddItem(visual_gui_toggle)

			local visual_gui_big_toggle = vgui.Create("DCheckBoxLabel")
			visual_gui_big_toggle:SetText("Visual GUI big popup")
			visual_gui_big_toggle:SetValue(TARDIS:GetSetting("visual_gui_bigpopup"))
			function visual_gui_big_toggle:OnChange(val)
				TARDIS:SetSetting("visual_gui_bigpopup", val)
			end
			panel:AddItem(visual_gui_big_toggle)

			local DLabel3 = vgui.Create( "DLabel" )
			DLabel3:SetText("Number of visual GUI button rows on the screen:")
			panel:AddItem(DLabel3)
			local visual_gui_screen_numrows = vgui.Create("DNumSlider")
			visual_gui_screen_numrows:SetMinMax(2, 10)
			visual_gui_screen_numrows:SetDecimals(0)
			visual_gui_screen_numrows:SetValue(TARDIS:GetSetting("visual_gui_screen_numrows"))
			function visual_gui_screen_numrows:OnValueChanged(val)
				val = math.floor(val)
				visual_gui_screen_numrows:SetValue(val)
				TARDIS:SetSetting("visual_gui_screen_numrows", val)
			end
			panel:AddItem(visual_gui_screen_numrows)

			local DLabel4 = vgui.Create( "DLabel" )
			DLabel4:SetText("Number of visual GUI button rows in the popup:")
			panel:AddItem(DLabel4)
			local visual_gui_popup_numrows = vgui.Create("DNumSlider")
			visual_gui_popup_numrows:SetMinMax(2, 10)
			visual_gui_popup_numrows:SetDecimals(0)
			visual_gui_popup_numrows:SetValue(TARDIS:GetSetting("visual_gui_popup_numrows"))
			function visual_gui_popup_numrows:OnValueChanged(val)
				val = math.floor(val)
				visual_gui_popup_numrows:SetValue(val)
				TARDIS:SetSetting("visual_gui_popup_numrows", val)
			end
			panel:AddItem(visual_gui_popup_numrows)

			local visual_gui_controls = vgui.Create("DCheckBoxLabel")
			visual_gui_controls:SetText("Enable controls in the visual GUI")
			visual_gui_controls:SetValue(TARDIS:GetSetting("visual_gui_controls"))
			function visual_gui_controls:OnChange(val)
				TARDIS:SetSetting("visual_gui_controls", val)
			end
			panel:AddItem(visual_gui_controls)
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
