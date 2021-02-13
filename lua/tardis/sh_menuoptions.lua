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
