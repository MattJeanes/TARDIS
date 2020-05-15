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
		end)
	end)
else
	util.AddNetworkString("TARDIS-DamageCvar")

	net.Receive("TARDIS-SvCvars", function(len, ply)
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			local val = net.ReadBool()
			RunConsoleCommand( "tardis2_damage", tostring(val) )
		end
	end)
end

-- cvars can either be a int, float, bool or string
