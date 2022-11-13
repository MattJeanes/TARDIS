hook.Add( "PopulateToolMenu", "tardisextendedsettings", function()
    
	spawnmenu.AddToolMenuOption( "Options", "TARDIS", "TardisExtendedOptions", "#Tardis Extended", "", "", function( panel )
		panel:ClearControls()
		panel:NumSlider( "Max amount of artron energy.", "te_maxartronenergy", 500, 50000 , 0)
        panel:CheckBox("Start with maximun energy.", "te_startwithmaxenergy")
		-- Add stuff here
	end )
end )