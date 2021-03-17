
TARDIS:AddControl("fastreturn",{
	func=function(self,ply)
		self:FastReturn()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("fastremat",{
	func=function(self,ply)
		self:ToggleFastRemat()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("power",{
	func=function(self,ply)
		self:TogglePower()
	end,
	interior=true,
	serveronly=true
})

TARDIS:AddControl("toggle_screens",{
	func=function(self,ply)
		self:ToggleScreens()
	end,
	interior=true,
	clientonly=true
})

TARDIS:AddControl("hads",{
	func=function(self,ply)
		self:ToggleHADS()
	end,
	exterior=true,
	serveronly=true,
})
TARDIS:AddControl("repair",{
	func=function(self,ply)
		self:ToggleRepair()
	end,
	exterior=true,
	serveronly=true
})
TARDIS:AddControl("physbrake",{
	func=function(self,ply)
		self:TogglePhyslock()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("doorcontroller",{
	func=function(self,ply)
		self:ToggleDoor()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("lockcontroller",{
	func=function(self,ply)
		self:ToggleLocked()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("teleport",{
	func=function(self,ply)
		if (self:GetData("teleport") or self:GetData("vortex")) then
			self:Mat()
		else
			self:Demat()
		end
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("flight",{
	func=function(self,ply)
		self:ToggleFlight()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("float",{
	func=function(self,ply)
		self:ToggleFloat()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("flightcontrol",{
	func=function(self,ply)
		self:PlayerThirdPerson(ply, not ply:GetTardisData("thirdperson"))
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("redecorate",{
	func=function(self,ply)
		local on = self:GetData("redecorate",false)
		self:SetData("redecorate", not on, true)
	end,
	exterior=true,
	serveronly=true
})


if SERVER then return end

local function old_virtual_console(self,ext,int,frame,screen)
	local power=vgui.Create("DButton",frame)
	power:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	power:SetPos(frame:GetWide()*0.13 - power:GetWide()*0.5,frame:GetTall()*0.15 - power:GetTall()*0.5)
	power:SetText("Toggle Power")
	power:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	power.DoClick = function()
		TARDIS:Control("power")
	end

	local repair=vgui.Create("DButton",frame)
	repair:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	repair:SetPos(frame:GetWide()*0.35 - repair:GetWide()*0.5,frame:GetTall()*0.15 - repair:GetTall()*0.5)
	repair:SetText("Repair TARDIS")
	repair:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	repair.DoClick = function()
		TARDIS:Control("repair")
	end

	local fastremat=vgui.Create("DButton",frame)
	fastremat:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	fastremat:SetPos(frame:GetWide()*0.13 - fastremat:GetWide()*0.5,frame:GetTall()*0.4 - fastremat:GetTall()*0.5)
	fastremat:SetText("Fast Remat "..(ext:GetData("demat-fast") and "on" or "off"))
	fastremat:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	fastremat.DoClick = function(self)
		TARDIS:Control("fastremat")
	end
	fastremat.oldon = ext:GetData("demat-fast")
	function fastremat:Think()
		local on = ext:GetData("demat-fast")
		if self.oldon == on then return end
		if on then
			self:SetText("Fast Remat on")
		else
			self:SetText("Fast Remat off")
		end
		self.oldon = on
	end

	local physbrake = vgui.Create("DButton",frame)
	physbrake:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2)
	physbrake:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	physbrake:SetPos((frame:GetWide()*0.35)-(physbrake:GetWide()*0.5),(frame:GetTall()*0.4)-(physbrake:GetTall()*0.5))
	physbrake:SetText("Physlock "..(ext:GetData("physlock") and "on" or "off"))
	physbrake.DoClick = function()
		TARDIS:Control("physbrake")
	end
	physbrake.oldon = ext:GetData("physlock")
	function physbrake:Think()
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
		TARDIS:Control("fastreturn")
	end

	local hads=vgui.Create("DButton",frame)
	hads:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	hads:SetPos(frame:GetWide()*0.35 - power:GetWide()*0.5,frame:GetTall()*0.65 - power:GetTall()*0.5)
	hads:SetText("HADS "..(ext:GetData("hads") and "on" or "off"))
	hads:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	hads.DoClick = function()
		TARDIS:Control("hads")
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
		TARDIS:Control("doorcontroller")
	end

	doorlock.DoClick = function()
		TARDIS:Control("lockcontroller")
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
	local layout = HexagonalLayout:new(frame, layout_rows, 0.15)

	-- controls

	if not screen.is3D2D then
		local interior_screens = TardisScreenButton:new(frame,screen)
		interior_screens:SetIsToggle(true)
		interior_screens:SetText("Toggle screens")
		interior_screens:SetControl("toggle_screens")
		interior_screens:SetPressedStateData(int, "screens_on")
		layout:AddNewButton(interior_screens)
	end

	local door = TardisScreenButton:new(frame,screen)
	door:SetIsToggle(true)
	door:SetText("Toggle door")
	door:SetControl("doorcontroller")
	door:SetPressedStateData(ext, "doorstate")
	layout:AddNewButton(door)

	local lock = TardisScreenButton:new(frame,screen)
	lock:SetIsToggle(true)
	lock:SetText("Toggle lock")
	lock:SetControl("lockcontroller")
	lock:SetPressedStateData(ext, "locked")
	layout:AddNewButton(lock)

	local power = TardisScreenButton:new(frame,screen)
	power:SetIsToggle(true)
	power:SetText("Toggle power")
	power:SetControl("power")
	power:SetPressedStateData(ext, "power-state")
	layout:AddNewButton(power)

	local repair = TardisScreenButton:new(frame,screen)
	repair:SetIsToggle(true)
	repair:SetText("Self-repair")
	repair:SetControl("repair")
	repair:SetPressedStateData(ext, "repair-primed")
	layout:AddNewButton(repair)

	local redecorate = TardisScreenButton:new(frame,screen)
	redecorate:SetIsToggle(true)
	redecorate:SetText("Redecoration")
	redecorate:SetControl("redecorate")
	redecorate:SetPressedStateData(ext, "redecorate")
	layout:AddNewButton(redecorate)

	local fastremat = TardisScreenButton:new(frame,screen)
	fastremat:SetIsToggle(true)
	fastremat:SetText("Vortex Flight")
	fastremat:SetControl("fastremat")
	fastremat:SetPressedStateData(ext, "demat-fast")
	layout:AddNewButton(fastremat)

	local throttle = TardisScreenButton:new(frame,screen)
	throttle:SetIsToggle(true)
	throttle:SetText("Throttle")
	throttle:SetControl("teleport")
	throttle:SetPressedStateData(ext, "teleport", "vortex")
	layout:AddNewButton(throttle)

	local fastreturn = TardisScreenButton:new(frame,screen)
	fastreturn:SetIsToggle(false)
	fastreturn:SetText("Fast Return")
	fastreturn:SetControl("fastreturn")
	layout:AddNewButton(fastreturn)

	local flight = TardisScreenButton:new(frame,screen)
	flight:SetIsToggle(true)
	flight:SetText("Flightmode")
	flight:SetControl("flight")
	flight:SetPressedStateData(ext, "flight")
	layout:AddNewButton(flight)

	local float = TardisScreenButton:new(frame,screen)
	float:SetIsToggle(true)
	float:SetText("Anti-Gravs")
	float:SetControl("float")
	float:SetPressedStateData(ext, "float")
	layout:AddNewButton(float)

	local physlock = TardisScreenButton:new(frame,screen)
	physlock:SetIsToggle(true)
	physlock:SetText("Physlock")
	physlock:SetControl("physbrake")
	physlock:SetPressedStateData(ext, "physlock")
	layout:AddNewButton(physlock)

	local hads = TardisScreenButton:new(frame,screen)
	hads:SetIsToggle(true)
	hads:SetText("H.A.D.S.")
	hads:SetControl("hads")
	hads:SetPressedStateData(ext, "hads")
	layout:AddNewButton(hads)

	local destination = TardisScreenButton:new(frame,screen)
	destination:SetIsToggle(false)
	destination:SetText("Destination Select")
	destination:SetControl("destination")
	layout:AddNewButton(destination)

	local flightcontrol = TardisScreenButton:new(frame,screen)
	flightcontrol:SetIsToggle(false)
	flightcontrol:SetText("Flight Control")
	flightcontrol:SetControl("flightcontrol")
	layout:AddNewButton(flightcontrol)

	layout:DrawButtons()

	layout.scroll_size = math.max(1, math.floor(layout:GetCols() / 2))

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

TARDIS:AddScreen("Console", {menu=false}, function(self,ext,int,frame,screen)
	if TARDIS:GetSetting("visgui_enabled") then
		new_virtual_console(self,ext,int,frame,screen)
	else
		old_virtual_console(self,ext,int,frame,screen)
	end
end)
