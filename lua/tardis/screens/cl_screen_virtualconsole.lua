-- Virtual console

local function new_virtual_console(self,ext,int,frame,screen)
	frame:SetBackgroundColor(Color(0,0,0))

	--background

	local background=vgui.Create("DImage", frame)

	local theme = TARDIS:GetSetting("visgui_theme")
	local background_img = TARDIS:GetGUIThemeElement(theme, "backgrounds", "virtualconsole")
	background:SetImage(background_img)
	background:SetSize(frame:GetWide(), frame:GetTall())

	local layout_rows
	if screen.is3D2D then
		if screen.visgui_rows == nil or TARDIS:GetSetting("visgui_override_numrows") then
			layout_rows = math.floor(TARDIS:GetSetting("visgui_screen_numrows"))
		else
			layout_rows = math.floor(screen.visgui_rows)
		end
	else
		layout_rows = math.floor(TARDIS:GetSetting("visgui_popup_numrows"))
	end
	local layout = HexagonalLayout:new(frame, layout_rows, 0.2)

	-- controls

	for k,control in pairs(TARDIS:GetControls()) do
		local options = control.screen_button
		if options and options.virt_console and not (screen.is3D2D and options.popup_only) then
			local button = TardisScreenButton:new(frame, screen)

			if not control.id and not options.id then
				error("control id is required for TARDIS screen button")
			end
			if options.id then
				button:SetID(options.id)
			else
				button:SetID(control.id)
			end
			button:SetControl(control.id)

			if options.toggle ~= nil then
				button:SetIsToggle(options.toggle)
			end
			if options.frame_type ~= nil then
				button:SetFrameType(options.frame_type[1], options.frame_type[2])
			end
			if options.text ~= nil then
				button:SetText(options.text)
			end
			if options.pressed_state_data ~= nil then
				local src = options.pressed_state_from_interior and int or ext
				button:SetPressedStateData(src, options.pressed_state_data)
			end
			if options.order ~= nil then
				button:SetOrder(options.order)
			end

			layout:AddNewButton(button)
		end
	end

	-- We keep these just in case someone needs custom buttons
	if IsValid(ext) then
		ext:CallHook("SetupVirtualConsole", screen, frame, layout)
	end
	if IsValid(int) then
		int:CallHook("SetupVirtualConsole", screen, frame, layout)
	end

	layout:DrawButtons()

	layout.scroll_size = math.max(1, layout:GetCols() - 1)

	frame.Think = function()
		screen.left_arrow:SetVisible(true)
		screen.right_arrow:SetVisible(true)
		screen.right_arrow.DoClick = function()
			if layout:CanMoveLeft()
				and not screen.left_arrow:IsPressed()
				and not screen.right_arrow:IsPressed() then
				layout:ScrollButtons(-layout.scroll_size)
			end
		end
		screen.left_arrow.DoClick = function()
			if layout:CanMoveRight()
				and not screen.right_arrow:IsPressed()
				and not screen.left_arrow:IsPressed() then
				layout:ScrollButtons(layout.scroll_size)
			end
		end
	end

end

local function old_virtual_console(self,ext,int,frame,screen)
	local power=vgui.Create("DButton",frame)
	power:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	power:SetPos(frame:GetWide()*0.13 - power:GetWide()*0.5,frame:GetTall()*0.15 - power:GetTall()*0.5)
	power:SetText("Toggle Power")
	power:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	power.DoClick = function()
		TARDIS:Control("power", LocalPlayer())
	end

	local repair=vgui.Create("DButton",frame)
	repair:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	repair:SetPos(frame:GetWide()*0.35 - repair:GetWide()*0.5,frame:GetTall()*0.15 - repair:GetTall()*0.5)
	repair:SetText("Repair TARDIS")
	repair:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	repair.DoClick = function()
		TARDIS:Control("repair", LocalPlayer())
	end

	local vortex_flight=vgui.Create("DButton",frame)
	vortex_flight:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	vortex_flight:SetPos(frame:GetWide()*0.13 - vortex_flight:GetWide()*0.5,frame:GetTall()*0.4 - vortex_flight:GetTall()*0.5)
	vortex_flight:SetText("Fast Remat "..(ext:GetData("demat-fast") and "on" or "off"))
	vortex_flight:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	vortex_flight.DoClick = function(self)
		TARDIS:Control("vortex_flight", LocalPlayer())
	end
	vortex_flight.oldon = ext:GetData("demat-fast")
	function vortex_flight:Think()
		local on = ext:GetData("demat-fast")
		if self.oldon == on then return end
		if on then
			self:SetText("Fast Remat on")
		else
			self:SetText("Fast Remat off")
		end
		self.oldon = on
	end

	local physlock = vgui.Create("DButton",frame)
	physlock:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2)
	physlock:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	physlock:SetPos((frame:GetWide()*0.35)-(physlock:GetWide()*0.5),(frame:GetTall()*0.4)-(physlock:GetTall()*0.5))
	physlock:SetText("Physlock "..(ext:GetData("physlock") and "on" or "off"))
	physlock.DoClick = function()
		TARDIS:Control("physlock", LocalPlayer())
	end
	physlock.oldon = ext:GetData("physlock")
	function physlock:Think()
		local on = ext:GetData("physlock", false)
		if self.oldon == on then return end
		if on then
			self:SetText("Physlock on")
		else
			self:SetText("Physlock off")
		end
		self.oldon = on
	end

	local fastreturn=vgui.Create("DButton",frame)
	fastreturn:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	fastreturn:SetPos(frame:GetWide()*0.13 - fastreturn:GetWide()*0.5,frame:GetTall()*0.65 - fastreturn:GetTall()*0.5)
	fastreturn:SetText("Fast Return")
	fastreturn:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	fastreturn.DoClick = function()
		TARDIS:Control("fastreturn", LocalPlayer())
	end

	local hads=vgui.Create("DButton",frame)
	hads:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	hads:SetPos(frame:GetWide()*0.35 - power:GetWide()*0.5,frame:GetTall()*0.65 - power:GetTall()*0.5)
	hads:SetText("HADS "..(ext:GetData("hads") and "on" or "off"))
	hads:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	hads.DoClick = function()
		TARDIS:Control("hads", LocalPlayer())
	end
	hads.oldon = ext:GetData("hads")
	function hads:Think()
		local on = ext:GetData("hads", false)
		if self.oldon == on then return end
		if on then
			self:SetText("HADS on")
		else
			self:SetText("HADS off")
		end
		self.oldon = on
	end

	local doorswitch = vgui.Create("DButton",frame)
	local doorlock = vgui.Create("DButton",frame)

	doorswitch:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1)
	doorswitch:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	doorswitch:SetPos((frame:GetWide()*0.57)-(doorswitch:GetWide()*0.5),(frame:GetTall()*0.15)-(doorswitch:GetTall()*1))
	doorswitch:SetText(ext:DoorOpen() and "Close door" or "Open door")

	doorlock:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1)
	doorlock:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	doorlock:SetPos((frame:GetWide()*0.57)-(doorlock:GetWide()*0.5),(frame:GetTall()*0.15)-(doorlock:GetTall()*0))
	doorlock:SetText(ext:Locked() and "Unlock door" or "Lock door")

	doorswitch.DoClick = function(doorswitch)
		TARDIS:Control("door", LocalPlayer())
	end

	doorlock.DoClick = function()
		TARDIS:Control("doorlock", LocalPlayer())
	end

	function doorswitch:Think()
		if ext:DoorMoving() then
			doorswitch.moving = true
			doorswitch.first = true
			if not doorswitch:GetDisabled() then
				if doorswitch.open then
					doorswitch:SetText("Door closing")
				else
					doorswitch:SetText("Door opening")
				end
				doorswitch:SetDisabled(true)
			end
		elseif doorswitch:GetDisabled() and not doorlock.lock then
			if not doorswitch.open then
				doorswitch.moving = false
			end
			doorswitch:SetDisabled(false)
		elseif ext:DoorOpen() and (not doorswitch.open) or doorswitch.first then
			if not doorswitch.moving then
				doorswitch.open = true
			end
			doorswitch:SetText("Close door")
			if doorswitch.first then
				doorswitch.first=nil
			end
		elseif not ext:DoorOpen() and doorswitch.open or doorswitch.first then
			doorswitch.open=false
			doorswitch:SetText("Open door")
			if doorswitch.first then
				doorswitch.first=nil
			end
		end
	end

	function doorlock:Think()
		if ext:Locking() then
			if not doorlock:GetDisabled() then
				if ext:Locked() then
					doorlock:SetText("Lock: Unlocking")
				else
					doorlock:SetText("Lock: Locking")
				end
				doorlock:SetDisabled(true)
			end
		elseif doorlock:GetDisabled() then
			doorlock:SetDisabled(false)
		elseif ext:Locked() and (not doorlock.lock) or doorlock.first then
			doorlock.lock=true
			doorlock:SetText("Unlock door")
			doorswitch:SetDisabled(true)
			if doorlock.first then
				doorlock.first=nil
			end
		elseif not ext:Locked() and doorlock.lock or doorlock.first then
			doorlock.lock=false
			doorlock:SetText("Lock door")
			doorswitch:SetDisabled(false)
			if doorlock.first then
				doorlock.first=nil
			end
		end
	end
end

TARDIS:AddScreen("Virtual Console", {id="virtualconsole",menu=false, order=1}, function(self,ext,int,frame,screen)
	if TARDIS:GetSetting("visgui_enabled") then
		new_virtual_console(self,ext,int,frame,screen)
	else
		old_virtual_console(self,ext,int,frame,screen)
	end
end)
