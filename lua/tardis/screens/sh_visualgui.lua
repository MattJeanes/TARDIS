if SERVER then return end

TARDIS:AddScreen("Visual GUI", {menu=false}, function(self,ext,int,frame,screen)

	if TARDIS:GetSetting("visual_gui_enabled")
	then

		frame:SetVisible(false)

		local background=vgui.Create("DImage", screen)
		background:SetImage("materials/vgui/tardis-desktops/default/i_background3.png")
		background:SetSize( screen:GetWide(), screen:GetTall() )
		--background:SetVisible(false)

		local toolbar_scale = 0.2
		local toolbar_button_scale = 0.9
		local toolbar_color = Color(1, 1, 100, 200)
		local button_panel_color = Color(100, 100, 0, 0)

		local toolbar = vgui.Create("DPanel", screen)
		toolbar:SetSize(screen:GetWide(), screen:GetTall() * toolbar_scale )
		toolbar:SetPos(0, screen:GetTall() - toolbar:GetTall() )
		toolbar:SetBackgroundColor(toolbar_color)

		local button_panel = vgui.Create("DPanel", screen)
		button_panel:SetSize(screen:GetWide(), screen:GetTall() - toolbar:GetTall())
		button_panel:SetPos(0, 0)
		button_panel:SetBackgroundColor(button_panel_color)

		local y_proportion = 0.866
		local button_gap_scale = 0.05
		local button_gap_size = button_panel:GetTall() * button_gap_scale
		local button_side_size = (button_panel:GetTall() - button_gap_size * 2.866) / 2.568
		local button_size = { 2 * button_side_size, 2 * button_side_size * y_proportion }
		local toolbar_button_size = { toolbar:GetTall() * toolbar_button_scale * 2, toolbar:GetTall() * toolbar_button_scale }

		--local scale = math.min(screen:GetWide()*0.4, screen:GetTall()*0.5)

		local current_button_pos = { button_panel:GetWide() * 0.2 - button_size[1] * 0.5, button_gap_size }
		local offset = { button_size[1] * 0.75 + 15, button_size[2] * 0.5 + 15 }

		function GetNewButton()
			local button = TardisScreenButton:new(button_panel)
			button:SetSize(button_size[1], button_size[2])
			button:SetPos(current_button_pos[1], current_button_pos[2])
			current_button_pos[1] = current_button_pos[1] + offset[1]
			current_button_pos[2] = current_button_pos[2] + offset[2]
			offset[2] = -offset[2]
			return button
		end

		local exit_popup_button = TardisScreenButton:new(toolbar)
		exit_popup_button:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		exit_popup_button:SetPos( toolbar:GetWide() * 0.5 - toolbar_button_size[1] * 0.5, toolbar:GetTall() * (1 - toolbar_button_scale) * 0.5 )
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
		left_arrow:SetPos( toolbar:GetWide() * 0.2 - toolbar_button_size[1] * 0.5, toolbar:GetTall() * (1 - toolbar_button_scale) * 0.5 )
		left_arrow:SetIsToggle(false)
		left_arrow:SetImages("materials/vgui/tardis-desktops/default/i_arrow_left.png")

		local right_arrow = TardisScreenButton:new(toolbar)
		right_arrow:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		right_arrow:SetPos( toolbar:GetWide() * 0.8 - toolbar_button_size[1] * 0.5, toolbar:GetTall() * (1 - toolbar_button_scale) * 0.5 )
		right_arrow:SetIsToggle(false)
		right_arrow:SetImages("materials/vgui/tardis-desktops/default/i_arrow_right.png")


		local door = GetNewButton()
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

		local fastreturn = GetNewButton()
		fastreturn:SetIsToggle(false)
		fastreturn:SetImages("materials/vgui/tardis-desktops/default/b_fastreturn.png", "materials/vgui/tardis-desktops/default/b_fastreturn_on.png")
		fastreturn.DoClick = function()
			TARDIS:Control("fastreturn")
		end

		local nextbutton1 = GetNewButton()
		nextbutton1:SetIsToggle(true)
		nextbutton1:SetToggle(true)
		nextbutton1.DoClick = function()
			--
		end
		nextbutton1.Think = function()
			--
		end

		local nextbutton2 = GetNewButton()
		nextbutton2:SetIsToggle(true)
		nextbutton2:SetToggle(true)
		nextbutton2.DoClick = function()
			--
		end
		nextbutton2.Think = function()
			--
		end


	end
end)
