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

TARDIS:AddSetting({
	id="visual_gui_bigpopup",
	name="Visual GUI big popup",
	desc="Should the popup for new visual GUI be bigger?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="visual_gui_screen_numrows",
	name="Visual GUI rows (screen)",
	desc="How many rows of buttons should the visual GUI on the screen have?",
	section="Misc",
	type="number",
	min=2,
	max=7,
	option=true,
	value=3
})

TARDIS:AddSetting({
	id="visual_gui_popup_numrows",
	name="Visual GUI rows (popup)",
	desc="How many rows of buttons should the visual GUI in the popup have?",
	section="Misc",
	type="number",
	min=2,
	max=7,
	option=true,
	value=4
})

TARDIS:AddSetting({
	id="visual_gui_controls",
	name="Visual GUI Controls",
	desc="Should new visual GUI have controls in it?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddScreen("Visual GUI", {menu=false}, function(self,ext,int,frame,screen)

	if TARDIS:GetSetting("visual_gui_enabled")
	then

		local theme = "materials/vgui/tardis-desktops/default/"

		frame:SetVisible(false)

		--background

		local background=vgui.Create("DImage", screen)
		background:SetImage(theme.."i_background3.png")
		background:SetSize( screen:GetWide(), screen:GetTall() )

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
		local toolbar_button_posY = toolbar:GetTall() * 0.5 - toolbar_button_size[2] * 0.5 --(1 - toolbar_button_scale) * 0.25
		exit_popup_button:SetPos( toolbar:GetWide() * 0.5 - toolbar_button_size[1] * 0.5, toolbar_button_posY)
		exit_popup_button:SetIsToggle(false)
		if not screen.is3D2D
		then
			exit_popup_button:SetImages(theme.."i_exit.png", theme.."i_exit_on.png")
			exit_popup_button.DoClick = function()
				TARDIS:RemoveHUDScreen()
			end
		else
			exit_popup_button:SetImages(theme.."i_popup.png", theme.."i_popup_on.png")
			exit_popup_button.DoClick = function()
				self:PopToScreen(screen.pagename:GetText())
			end
		end

		local left_arrow = TardisScreenButton:new(toolbar)
		left_arrow:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		left_arrow:SetPos( toolbar:GetWide() * 0.2 - toolbar_button_size[1] * 0.5, toolbar_button_posY)
		left_arrow:SetIsToggle(false)
		left_arrow:SetImages(theme.."i_arrow_left.png", theme.."i_arrow_left_on.png")

		local right_arrow = TardisScreenButton:new(toolbar)
		right_arrow:SetSize(toolbar_button_size[1], toolbar_button_size[2])
		right_arrow:SetPos( toolbar:GetWide() * 0.8 - toolbar_button_size[1] * 0.5, toolbar_button_posY)
		right_arrow:SetIsToggle(false)
		right_arrow:SetImages(theme.."i_arrow_right.png", theme.."i_arrow_right_on.png")


		-- button panel

		local button_panel_color = Color(100, 100, 0, 0)
		local button_panel = vgui.Create("DPanel", screen)
		button_panel:SetSize(screen:GetWide(), screen:GetTall() - toolbar:GetTall())
		button_panel:SetPos(0, 0)
		button_panel:SetBackgroundColor(button_panel_color)

		local layout_rows
		if screen.is3D2D
		then
			layout_rows = math.floor(TARDIS:GetSetting("visual_gui_screen_numrows"))
		else
			layout_rows = math.floor(TARDIS:GetSetting("visual_gui_popup_numrows"))
		end
		local layout = HexagonalLayout:new(button_panel, layout_rows, 0.15)

		-- controls

		if TARDIS:GetSetting("visual_gui_controls")
		then

			local door = TardisScreenButton:new(button_panel)
			door:SetIsToggle(true)
			door:SetImages(theme.."l_door_closed.png", theme.."l_door_open.png")
			door:SetControl("doorcontroller")
			door:SetPressedStateData(ext, "doorstate")
			layout:AddNewButton(door)

			local lock = TardisScreenButton:new(button_panel)
			lock:SetIsToggle(true)
			lock:SetImages(theme.."l_lock_off.png", theme.."l_lock_on.png")
			lock:SetControl("lockcontroller")
			lock:SetPressedStateData(ext, "locked")
			layout:AddNewButton(lock)

			local power = TardisScreenButton:new(button_panel)
			power:SetIsToggle(true)
			power:SetImages(theme.."l_power_off.png", theme.."l_power_on.png")
			power:SetControl("power")
			power:SetPressedStateData(ext, "power-state")
			layout:AddNewButton(power)

			local repair = TardisScreenButton:new(button_panel)
			repair:SetIsToggle(true)
			repair:SetImages(theme.."l_repair_off.png", theme.."l_repair_on.png")
			repair:SetControl("repair")
			repair:SetPressedStateData(ext, "repair-primed")
			layout:AddNewButton(repair)

			local fastremat = TardisScreenButton:new(button_panel)
			fastremat:SetIsToggle(true)
			fastremat:SetImages(theme.."l_fastremat_off.png", theme.."l_fastremat_on.png")
			fastremat:SetControl("fastremat")
			fastremat:SetPressedStateData(ext, "demat-fast")
			layout:AddNewButton(fastremat)

			local throttle = TardisScreenButton:new(button_panel)
			throttle:SetIsToggle(true)
			throttle:SetImages(theme.."l_throttle_off.png", theme.."l_throttle_on.png")
			throttle:SetControl("teleport")
			throttle:SetPressedStateData(ext, "teleport", "vortex")
			layout:AddNewButton(throttle)

			local fastreturn = TardisScreenButton:new(button_panel)
			fastreturn:SetIsToggle(false)
			fastreturn:SetImages(theme.."b_fastreturn.png", theme.."b_fastreturn_on.png")
			fastreturn:SetControl("fastreturn")
			layout:AddNewButton(fastreturn)

			local flight = TardisScreenButton:new(button_panel)
			flight:SetIsToggle(true)
			flight:SetImages(theme.."l_flight_off.png", theme.."l_flight_on.png")
			flight:SetControl("flight")
			flight:SetPressedStateData(ext, "flight")
			layout:AddNewButton(flight)

			local float = TardisScreenButton:new(button_panel)
			float:SetIsToggle(true)
			float:SetImages(theme.."l_float_off.png", theme.."l_float_on.png")
			float:SetControl("float")
			float:SetPressedStateData(ext, "float")
			layout:AddNewButton(float)

			local physlock = TardisScreenButton:new(button_panel)
			physlock:SetIsToggle(true)
			physlock:SetImages(theme.."l_physlock_off.png", theme.."l_physlock_on.png")
			physlock:SetControl("physbrake")
			physlock:SetPressedStateData(ext, "physlock")
			layout:AddNewButton(physlock)

			local hads = TardisScreenButton:new(button_panel)
			hads:SetIsToggle(true)
			hads:SetImages(theme.."l_hads_off.png", theme.."l_hads_on.png")
			hads:SetControl("hads")
			hads:SetPressedStateData(ext, "hads")
			layout:AddNewButton(hads)

		end

		local destination = TardisScreenButton:new(button_panel)
		destination:SetIsToggle(false)
		destination:SetImages(theme.."b_manualselect.png")
		destination:SetControl("destination")
		layout:AddNewButton(destination)

		local flightcontrol = TardisScreenButton:new(button_panel)
		flightcontrol:SetIsToggle(false)
		flightcontrol:SetImages(theme.."b_flightcontrol.png")
		flightcontrol:SetControl("flightcontrol")
		layout:AddNewButton(flightcontrol)

		local music = TardisScreenButton:new(button_panel)
		music:SetIsToggle(false)
		music:SetImages(theme.."b_music.png")
		layout:AddNewButton(music)

		local scanner = TardisScreenButton:new(button_panel)
		scanner:SetIsToggle(false)
		scanner:SetImages(theme.."b_scanner.png")
		layout:AddNewButton(scanner)

		local coords = TardisScreenButton:new(button_panel)
		coords:SetIsToggle(false)
		coords:SetImages(theme.."b_coordselect.png")
		layout:AddNewButton(coords)

		local settings = TardisScreenButton:new(button_panel)
		settings:SetIsToggle(false)
		settings:SetImages(theme.."b_settings.png")
		layout:AddNewButton(settings)

		layout:DrawButtons()

		local scroll_size = math.floor(layout:GetCols() / 2)
		local total_scroll = 0
		right_arrow.DoClick = function()
			total_scroll = total_scroll + scroll_size
			layout:ScrollButtons(-scroll_size)
		end
		left_arrow.DoClick = function()
			if total_scroll - scroll_size >= 0
			then
				total_scroll = total_scroll - scroll_size
				layout:ScrollButtons(scroll_size)
			end
		end

		--if screen.is3D2D
		--then
		--	button_panel:SetSize(button_panel:GetWide() - 2 * layout:GetButtonSize(1), button_panel:GetTall())
		--	button_panel:SetPos(layout:GetButtonSize(1), 0)
		--	layout:ScrollButtons(-1)
		--end

	end
end)
