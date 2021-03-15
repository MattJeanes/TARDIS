local checkbox_options={
	{"Flight sounds", "tardis_flightsound"},
	{"Teleport sounds", "tardis_matsound"},
	{"Door sounds", "tardis_doorsound"},
	{"Lock sounds", "tardis_locksound"},
	{"Phase sounds", "tardis_phasesound"},
	{"Repair sounds", "tardisint_repairsound"},
	{"Power sounds", "tardisint_powersound"},
	{"Cloisterbell sound", "tardisint_cloisterbell"},
	{"Flightmode music", "tardisint_musicext"},
	{"Interior idle sounds", "tardisint_idlesound"},
	{"Interior control sounds", "tardisint_controlsound"},
	{"Interior music", "tardisint_music"},
	{"Interior scanner", "tardisint_scanner"},
	{"Interior dynamic light", "tardisint_dynamiclight"},
	{"Exterior dynamic light", "tardis_dynamiclight"},
	{"Control tool tips", "tardisint_tooltip"},
	{"Control halos", "tardisint_halos"},
}

for k,v in pairs(checkbox_options) do
	CreateClientConVar(v[2], "1", true)
end

local special_checkbox_options={
	{"Exterior snow", "tardis_specialtex", "0", true},
	{"Interior rails", "tardisint_rails", "1", true},
}

for k,v in pairs(special_checkbox_options) do
	CreateClientConVar(v[2], v[3], true, v[4])
end

CreateClientConVar("tardisint_musicvol", "1", true)
CreateClientConVar("tardis_flightvol", "1", true)

CreateClientConVar("tardisint_mainlight_r", "255", true, true)
CreateClientConVar("tardisint_mainlight_g", "50", true, true)
CreateClientConVar("tardisint_mainlight_b", "0", true, true)

CreateClientConVar("tardisint_seclight_r", "0", true, true)
CreateClientConVar("tardisint_seclight_g", "255", true, true)
CreateClientConVar("tardisint_seclight_b", "0", true, true)

CreateClientConVar("tardisint_warnlight_r", "200", true, true)
CreateClientConVar("tardisint_warnlight_g", "0", true, true)
CreateClientConVar("tardisint_warnlight_b", "0", true, true)

CreateClientConVar("tardis_globalskin", "0", true, true)
CreateClientConVar("tardis_specialtex", "0", true, true)

CreateClientConVar("tardis_extcol_r", "255", true, true)
CreateClientConVar("tardis_extcol_g", "255", true, true)
CreateClientConVar("tardis_extcol_b", "255", true, true)

hook.Add("PopulateToolMenu", "TARDIS-PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Doctor Who", "TARDIS_Options", "TARDIS (Legacy)", "", "", function(panel)
		panel:ClearControls()
		//Do menu things here
		
		local button = vgui.Create("DButton")
		button:SetText("Advanced Mode Help")
		button.DoClick = function(self)
			local window = vgui.Create( "DFrame" )
			window:SetSize( 415,220 )
			window:Center()
			window:SetTitle( "TARDIS Advanced Mode Help" )
			window:MakePopup()

			local DLabel = vgui.Create( "DLabel", window )
			DLabel:SetPos(7.5,30)
			DLabel:SetText(
				[[
				The TARDIS advanced flight mode requires the player to press a series of controls
				around the console area in order to successfully dematerialise.
				
				This build of the mod requires the following combination of controls (in order):
				
				1. Activate the flightmode (Navigations/Programmable/Vortex)
				2. Dial the Helmic Regulator
				3. Apply the Locking Down Mechanism
				4. Release the Time-Rotor Handbrake
				5. Alternate the Space-Time Throttle
				
				Sounds will indicate if you have pressed the correct control or the wrong control.
				
				Happy dematerialising!
				]]
			)
			DLabel:SizeToContents()
		end
		panel:AddItem(button)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Double spawn trace (Admin Only)" )
		checkBox:SetToolTip( "This should fix some maps where the interior/skycamera doesn't spawn properly" )
		checkBox:SetValue( GetConVarNumber( "tardis_doubletrace" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-DoubleTrace")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Take damage (Admin Only)" )
		checkBox:SetValue( GetConVarNumber( "tardis_takedamage" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-TakeDamage")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end			
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Allow phasing in flightmode (Admin Only)" )
		checkBox:SetValue( GetConVarNumber( "tardis_flightphase" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-FlightPhase")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Physical Damage (Admin Only)" )
		checkBox:SetToolTip( "This enables/disables physical damage from hitting stuff at high speeds." )
		checkBox:SetValue( GetConVarNumber( "tardis_physdamage" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-PhysDamage")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "No-collide during teleport (Admin Only)" )
		checkBox:SetToolTip( "This enables no-collide on the TARDIS when it is teleporting and disables it after again." )
		checkBox:SetValue( GetConVarNumber( "tardis_nocollideteleport" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-NoCollideTeleport")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Advanced Mode (Admin Only)" )
		checkBox:SetToolTip( "This sets interior navigation to advanced, turn off for easy." )
		checkBox:SetValue( GetConVarNumber( "tardis_advanced" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-AdvancedMode")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		local checkBox = vgui.Create( "DCheckBoxLabel" )
		checkBox:SetText( "Lock doors during teleport (Admin Only)" )
		checkBox:SetToolTip( "This stops players from entering/leaving while it is teleporting." )
		checkBox:SetValue( GetConVarNumber( "tardis_teleportlock" ) )
		checkBox:SetDisabled(not (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()))
		checkBox.OnChange = function(self,val)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				net.Start("TARDIS-TeleportLock")
					net.WriteFloat(val==true and 1 or 0)
				net.SendToServer()
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
				chat.PlaySound()
			end
		end
		panel:AddItem(checkBox)
		
		/* -- i feel people arnt going to know what this does and end up breaking everything, the above checkbox should help in most cases.
		local slider = vgui.Create( "DNumSlider" )
			slider:SetText( "Spawn Offset (Admin Only)" )
			slider:SetToolTip("Try the above checkbox first, this is a last resort for advanced users only.")
			slider:SetValue(0)
			slider:SetDecimals(0)
			slider:SetMin(-10000)
			slider:SetMax(5000)
			slider.val=0
			slider.OnValueChanged = function(self,val)
				if not (slider.val==val) then
					slider.val=val
					if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
						net.Start("TARDIS-SpawnOffset")
							net.WriteFloat(val)
						net.SendToServer()
					else
						chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to change this option.")
						chat.PlaySound()
					end
				end
			end
			panel:AddItem(slider)
			
		local button = vgui.Create( "DButton" )
		button:SetText( "Reset Spawn Offset" )
		button.DoClick = function(self)
			if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
				if slider then
					slider:SetValue(0)
				end
			else
				chat.AddText(Color(255,62,62), "WARNING: ", Color(255,255,255), "You must be an admin to use this button.")
				chat.PlaySound()
			end
		end
		panel:AddItem(button)
		*/
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Colors:")
		panel:AddItem(DLabel)
		
		local CategoryList = vgui.Create( "DPanelList" )
		//CategoryList:SetAutoSize( true )
		CategoryList:SetTall( 260 )
		CategoryList:SetSpacing( 10 )
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Exterior Lamp:")
		CategoryList:AddItem(DLabel)
		
		local Mixer = vgui.Create( "DColorMixer" )
		Mixer:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer:SetColor( Color(GetConVarNumber("tardis_extcol_r"), GetConVarNumber("tardis_extcol_g"), GetConVarNumber("tardis_extcol_b")) )	--Set the default color
		Mixer.ValueChanged = function(self,col)
			RunConsoleCommand("tardis_extcol_r", col.r)
			RunConsoleCommand("tardis_extcol_g", col.g)
			RunConsoleCommand("tardis_extcol_b", col.b)
		end
		CategoryList:AddItem(Mixer)
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Interior Main:")
		CategoryList:AddItem(DLabel)
		
		local Mixer1 = vgui.Create( "DColorMixer" )
		Mixer1:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer1:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer1:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer1:SetColor( Color(GetConVarNumber("tardisint_mainlight_r"), GetConVarNumber("tardisint_mainlight_g"), GetConVarNumber("tardisint_mainlight_b")) )	--Set the default color
		Mixer1.ValueChanged = function(self,col)
			RunConsoleCommand("tardisint_mainlight_r", col.r)
			RunConsoleCommand("tardisint_mainlight_g", col.g)
			RunConsoleCommand("tardisint_mainlight_b", col.b)
		end
		CategoryList:AddItem(Mixer1)
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Interior Secondary:")
		CategoryList:AddItem(DLabel)
		
		local Mixer2 = vgui.Create( "DColorMixer" )
		Mixer2:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer2:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer2:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer2:SetColor( Color(GetConVarNumber("tardisint_seclight_r"), GetConVarNumber("tardisint_seclight_g"), GetConVarNumber("tardisint_seclight_b")) )	--Set the default color
		Mixer2.ValueChanged = function(self,col)
			RunConsoleCommand("tardisint_seclight_r", col.r)
			RunConsoleCommand("tardisint_seclight_g", col.g)
			RunConsoleCommand("tardisint_seclight_b", col.b)
		end
		CategoryList:AddItem(Mixer2)
		
		local DLabel = vgui.Create( "DLabel" )
		DLabel:SetText("Interior Warning:")
		CategoryList:AddItem(DLabel)
		
		local Mixer3 = vgui.Create( "DColorMixer" )
		Mixer3:SetPalette( true )  		--Show/hide the palette			DEF:true
		Mixer3:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
		Mixer3:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer3:SetColor( Color(GetConVarNumber("tardisint_warnlight_r"), GetConVarNumber("tardisint_warnlight_g"), GetConVarNumber("tardisint_warnlight_b")) )	--Set the default color
		Mixer3.ValueChanged = function(self,col)
			RunConsoleCommand("tardisint_warnlight_r", col.r)
			RunConsoleCommand("tardisint_warnlight_g", col.g)
			RunConsoleCommand("tardisint_warnlight_b", col.b)
		end
		CategoryList:AddItem(Mixer3)
		
		panel:AddItem(CategoryList)
		
		local button = vgui.Create("DButton")
		button:SetText("Reset Colors")
		button.DoClick = function(self)
			Mixer:SetColor(Color(255,255,255))
			Mixer1:SetColor(Color(255,50,0))
			Mixer2:SetColor(Color(0,255,0))
			Mixer3:SetColor(Color(200,0,0))
		end
		panel:AddItem(button)
		
		panel:AddControl("Slider", {
			Label="Music Volume",
			Type="float",
			Min=0.1,
			Max=1,
			Command="tardisint_musicvol",
		})
		
		panel:AddControl("Slider", {
			Label="Exterior Flight Volume",
			Type="float",
			Min=0.1,
			Max=1,
			Command="tardis_flightvol",
		})
		
		
		local skins={
			{"War Doctor Skin", 3},
			{"2005 Skin", 1},
			{"Old 2010 Skin", 2},
			{"2010 Skin", 0},
		}
		local comboBox = vgui.Create("DComboBox")
		comboBox:SetText("Global Skin")
		for k,v in ipairs(skins) do
			comboBox:AddChoice(v[1])
		end
		for k,v in pairs(skins) do
			if GetConVarNumber("tardis_globalskin")==v[2] then
				comboBox:ChooseOption(v[1])
			end
		end
		comboBox.OnSelect = function(panel,index,value,data)
			local n=0
			for k,v in pairs(skins) do
				if value==v[1] then
					n=v[2]
				end
			end
			RunConsoleCommand("tardis_globalskin", n)
		end
		panel:AddItem(comboBox)
		
		local checkboxes={}
		for k,v in pairs(special_checkbox_options) do
			local checkBox = vgui.Create( "DCheckBoxLabel" ) 
			checkBox:SetText( v[1] ) 
			checkBox:SetValue( GetConVarNumber( v[2] ) )
			checkBox:SetConVar( v[2] )
			panel:AddItem(checkBox)
			table.insert(checkboxes, checkBox)
		end
		
		for k,v in pairs(checkbox_options) do
			local checkBox = vgui.Create( "DCheckBoxLabel" ) 
			checkBox:SetText( v[1] ) 
			checkBox:SetValue( GetConVarNumber( v[2] ) )
			checkBox:SetConVar( v[2] )
			panel:AddItem(checkBox)
			table.insert(checkboxes, checkBox)
		end
	end)
end)
