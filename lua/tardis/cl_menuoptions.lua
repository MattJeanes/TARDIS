hook.Add("PopulateToolMenu", "TARDIS2-PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Doctor Who", "TARDIS2_Options", "TARDIS Rewrite", "", "", function(panel)
		panel:ClearControls()
		//Do menu things here
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("The TARDIS Interface is available at any time using the button below:")
		panel:AddItem(DLabel)
		
		local button = vgui.Create("DButton")
		button:SetText("Open TARDIS Interface")
		button.DoClick = function(self)
			TARDIS:HUDScreen()
		end
		panel:AddItem(button)
	end)
end)