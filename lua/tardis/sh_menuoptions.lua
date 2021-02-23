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

			local interior_combobox = vgui.Create("DComboBox")
			interior_combobox:SetText("Interior")
			for k,v in pairs(TARDIS:GetInteriors()) do
				if v.Base != true
				then
					v.OptionID=interior_combobox:AddChoice(v.Name,v.ID)
				end
			end
			local selectedinterior=TARDIS:GetSetting("interior","default")
			for k,v in pairs(TARDIS:GetInteriors()) do
				if selectedinterior==v.ID then
					interior_combobox:ChooseOption(v.OptionID)
					interior_combobox:SetText(v.Name)
				end
			end
			interior_combobox.OnSelect = function(panel,index,value,data)
				TARDIS:SetSetting("interior",data,true)
				LocalPlayer():ChatPrint("TARDIS interior changed. Respawn or repair the TARDIS for changes to apply.")
			end
			panel:AddItem(interior_combobox)

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

			local DLabel4 = vgui.Create( "DLabel" )
			DLabel4:SetText("TARDIS Visual GUI Theme:")
			panel:AddItem(DLabel4)

			local visual_gui_theme = vgui.Create("DComboBox")
			visual_gui_theme:SetText("Visual GUI Theme")
			local themes = {}
			local theme_basefolder = TARDIS.visualgui_theme_basefolder
			local files, folders = file.Find(theme_basefolder.."*", "GAME", "nameasc")
			for k,folder in pairs(folders) do
				if file.Exists(theme_basefolder..folder.."/default_on.png", "GAME")
					and file.Exists(theme_basefolder..folder.."/default_off.png", "GAME")
					and file.Exists(theme_basefolder..folder.."/background.png", "GAME")
				then
					local theme = {}
					theme.ID = visual_gui_theme:AddChoice(folder)
					theme.name = folder
					table.insert(themes, theme)
				end
			end
			local selectedtheme=TARDIS:GetSetting("visual_gui_theme", "default")
			for k,theme in pairs(themes) do
				if selectedtheme == theme.name then
					visual_gui_theme:ChooseOption(theme.ID)
					visual_gui_theme:SetText(theme.name)
				end
			end
			visual_gui_theme.OnSelect = function(panel, index, value)
				TARDIS:SetSetting("visual_gui_theme", value)
				LocalPlayer():ChatPrint("TARDIS visual GUI theme changed to "..value)
			end
			panel:AddItem(visual_gui_theme)
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
