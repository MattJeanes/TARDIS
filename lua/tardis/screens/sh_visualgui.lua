if SERVER then return end

TARDIS:AddSetting({
	id="visual_gui_enabled",
	name="Visual GUI Enabled",
	desc="Should new visual GUI be used?",
	section="Misc",
	value=false,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddScreen("Visual GUI", {menu=false}, function(self,ext,int,frame,screen)

	if TARDIS:GetSetting("visual_gui_enabled")
	then

		frame:SetVisible(false)

		--background

		local background=vgui.Create("DImage", screen)
		background:SetImage("materials/vgui/tardis-desktops/default/i_background3.png")
		background:SetSize( screen:GetWide(), screen:GetTall() )
		--background:SetVisible(false)

		-- toolbar

		local toolbar_scale = 0.2
		local toolbar_button_scale = 0.75
		local toolbar_color = Color(1, 1, 100, 200)

		local toolbar = vgui.Create("DPanel", screen)
		toolbar:SetSize(screen:GetWide(), screen:GetTall() * toolbar_scale )
		toolbar:SetPos(0, screen:GetTall() - toolbar:GetTall() )
		toolbar:SetBackgroundColor(toolbar_color)

		local toolbar_button_size = { toolbar:GetTall() * toolbar_button_scale * 2, toolbar:GetTall() * toolbar_button_scale }

		local exit_popup_button = TardisScreenButton:new(toolbar)
		exit_popup_button:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		exit_popup_button:SetPos( toolbar:GetWide() * 0.5 - toolbar_button_size[1] * 0.5, toolbar:GetTall() * (1 - toolbar_button_scale) * 0.25 )
		exit_popup_button:SetIsToggle(false)
		if not screen.is3D2D
		then
			exit_popup_button:SetImages("materials/vgui/tardis-desktops/default/i_exit.png")
			exit_popup_button.DoClick = function()
				TARDIS:RemoveHUDScreen()
			end
		else
			exit_popup_button:SetImages("materials/vgui/tardis-desktops/default/i_popup.png")
			exit_popup_button.DoClick = function()
				self:PopToScreen(screen.pagename:GetText())
			end
		end

		local left_arrow = TardisScreenButton:new(toolbar)
		left_arrow:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		left_arrow:SetPos( toolbar:GetWide() * 0.2 - toolbar_button_size[1] * 0.5, toolbar:GetTall() * (1 - toolbar_button_scale) * 0.25 )
		left_arrow:SetIsToggle(false)
		left_arrow:SetImages("materials/vgui/tardis-desktops/default/i_arrow_left.png")

		local right_arrow = TardisScreenButton:new(toolbar)
		right_arrow:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		right_arrow:SetPos( toolbar:GetWide() * 0.8 - toolbar_button_size[1] * 0.5, toolbar:GetTall() * (1 - toolbar_button_scale) * 0.25 )
		right_arrow:SetIsToggle(false)
		right_arrow:SetImages("materials/vgui/tardis-desktops/default/i_arrow_right.png")


		-- button panel

		local button_panel_color = Color(100, 100, 0, 0)
		local button_panel = vgui.Create("DPanel", screen)
		button_panel:SetSize(screen:GetWide(), screen:GetTall() - toolbar:GetTall())
		button_panel:SetPos(0, 0)
		button_panel:SetBackgroundColor(button_panel_color)

		local layout = HexagonalLayout:new(button_panel, 3, 0.1)

		local door = TardisScreenButton:new(button_panel)
		door:SetIsToggle(true)
		door:SetToggle(ext:DoorOpen())
		door:SetImages("materials/vgui/tardis-desktops/default/l_door_closed.png", "materials/vgui/tardis-desktops/default/l_door_open.png")
		door.DoClick = function()
			TARDIS:Control("doorcontroller")
			door:SetToggle(ext:DoorOpen())
		end
		door.Think = function()
			door:SetToggle(ext:DoorOpen())
		end
		layout:AddNewButton(door)

		local fastreturn = TardisScreenButton:new(button_panel)
		fastreturn:SetIsToggle(false)
		fastreturn:SetImages("materials/vgui/tardis-desktops/default/b_fastreturn.png", "materials/vgui/tardis-desktops/default/b_fastreturn_on.png")
		fastreturn.DoClick = function()
			TARDIS:Control("fastreturn")
		end
		layout:AddNewButton(fastreturn)

		local nextbutton1 = TardisScreenButton:new(button_panel)
		nextbutton1:SetIsToggle(true)
		nextbutton1:SetToggle(true)
		nextbutton1.DoClick = function()
			--
		end
		nextbutton1.Think = function()
			--
		end
		layout:AddNewButton(nextbutton1)

		local nextbutton2 = TardisScreenButton:new(button_panel)
		nextbutton2:SetIsToggle(true)
		nextbutton2:SetToggle(true)
		nextbutton2.DoClick = function()
			--
		end
		nextbutton2.Think = function()
			--
		end
		layout:AddNewButton(nextbutton2)

		layout:DrawButtons()
		right_arrow.DoClick = function()
			layout:ScrollButtons(1)
			layout:DrawButtons()
		end
		left_arrow.DoClick = function()
			layout:ScrollButtons(-1)
			layout:DrawButtons()
		end

	end
end)
