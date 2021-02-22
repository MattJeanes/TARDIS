
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
		if (self:GetData("teleport") or self:GetData("vortex"))
		then
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


if SERVER then return end

local function old_virtual_console(self,ext,int,frame,screen)
	local power=vgui.Create("DButton",frame)
	power:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	power:SetPos(frame:GetWide()*0.13 - power:GetWide()*0.5,frame:GetTall()*0.15 - power:GetTall()*0.5)
	power:SetText("Toggle Power")
	power:SetFont("TARDIS-Default")
	power.DoClick = function()
		TARDIS:Control("power")
	end

	local repair=vgui.Create("DButton",frame)
	repair:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	repair:SetPos(frame:GetWide()*0.35 - repair:GetWide()*0.5,frame:GetTall()*0.15 - repair:GetTall()*0.5)
	repair:SetText("Repair TARDIS")
	repair:SetFont("TARDIS-Default")
	repair.DoClick = function()
		TARDIS:Control("repair")
	end

	local fastremat=vgui.Create("DButton",frame)
	fastremat:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	fastremat:SetPos(frame:GetWide()*0.13 - fastremat:GetWide()*0.5,frame:GetTall()*0.4 - fastremat:GetTall()*0.5)
	fastremat:SetText("Fast Remat "..(ext:GetData("demat-fast") and "on" or "off"))
	fastremat:SetFont("TARDIS-Default")
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
	physbrake:SetFont("TARDIS-Default")
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
	fastreturn:SetFont("TARDIS-Default")
	fastreturn.DoClick = function()
		TARDIS:Control("fastreturn")
	end

	local hads=vgui.Create("DButton",frame)
	hads:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	hads:SetPos(frame:GetWide()*0.35 - power:GetWide()*0.5,frame:GetTall()*0.65 - power:GetTall()*0.5)
	hads:SetText("HADS "..(ext:GetData("hads") and "on" or "off"))
	hads:SetFont("TARDIS-Default")
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
	doorswitch:SetFont("TARDIS-Default")
	doorswitch:SetPos((frame:GetWide()*0.57)-(doorswitch:GetWide()*0.5),(frame:GetTall()*0.15)-(doorswitch:GetTall()*1))
	doorswitch:SetText(ext:DoorOpen() and "Close door" or "Open door")

	doorlock:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1)
	doorlock:SetFont("TARDIS-Default")
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
	local theme = "materials/vgui/tardis-desktops/default/"
	frame:SetBackgroundColor(Color(0,0,0))

	--background

	local background=vgui.Create("DImage", frame)
	background:SetImage(theme.."i_background3.png")
	background:SetSize( frame:GetWide(), frame:GetTall() )

	local layout_rows
	if screen.is3D2D
	then
		layout_rows = math.floor(TARDIS:GetSetting("visual_gui_screen_numrows"))
	else
		layout_rows = math.floor(TARDIS:GetSetting("visual_gui_popup_numrows"))
	end
	local layout = HexagonalLayout:new(frame, layout_rows, 0.15)

	-- controls

	local door = TardisScreenButton:new(frame)
	door:SetIsToggle(true)
	door:SetImages(theme.."l_door_closed.png", theme.."l_door_open.png")
	door:SetControl("doorcontroller")
	door:SetPressedStateData(ext, "doorstate")
	layout:AddNewButton(door)

	local lock = TardisScreenButton:new(frame)
	lock:SetIsToggle(true)
	lock:SetImages(theme.."l_lock_off.png", theme.."l_lock_on.png")
	lock:SetControl("lockcontroller")
	lock:SetPressedStateData(ext, "locked")
	layout:AddNewButton(lock)

	local power = TardisScreenButton:new(frame)
	power:SetIsToggle(true)
	power:SetImages(theme.."l_power_off.png", theme.."l_power_on.png")
	power:SetControl("power")
	power:SetPressedStateData(ext, "power-state")
	layout:AddNewButton(power)

	local repair = TardisScreenButton:new(frame)
	repair:SetIsToggle(true)
	repair:SetImages(theme.."l_repair_off.png", theme.."l_repair_on.png")
	repair:SetControl("repair")
	repair:SetPressedStateData(ext, "repair-primed")
	layout:AddNewButton(repair)

	local fastremat = TardisScreenButton:new(frame)
	fastremat:SetIsToggle(true)
	fastremat:SetImages(theme.."l_fastremat_off.png", theme.."l_fastremat_on.png")
	fastremat:SetControl("fastremat")
	fastremat:SetPressedStateData(ext, "demat-fast")
	layout:AddNewButton(fastremat)

	local throttle = TardisScreenButton:new(frame)
	throttle:SetIsToggle(true)
	throttle:SetImages(theme.."l_throttle_off.png", theme.."l_throttle_on.png")
	throttle:SetControl("teleport")
	throttle:SetPressedStateData(ext, "teleport", "vortex")
	layout:AddNewButton(throttle)

	local fastreturn = TardisScreenButton:new(frame)
	fastreturn:SetIsToggle(false)
	fastreturn:SetImages(theme.."b_fastreturn.png", theme.."b_fastreturn_on.png")
	fastreturn:SetControl("fastreturn")
	layout:AddNewButton(fastreturn)

	local flight = TardisScreenButton:new(frame)
	flight:SetIsToggle(true)
	flight:SetImages(theme.."l_flight_off.png", theme.."l_flight_on.png")
	flight:SetControl("flight")
	flight:SetPressedStateData(ext, "flight")
	layout:AddNewButton(flight)

	local float = TardisScreenButton:new(frame)
	float:SetIsToggle(true)
	float:SetImages(theme.."l_float_off.png", theme.."l_float_on.png")
	float:SetControl("float")
	float:SetPressedStateData(ext, "float")
	layout:AddNewButton(float)

	local physlock = TardisScreenButton:new(frame)
	physlock:SetIsToggle(true)
	physlock:SetImages(theme.."l_physlock_off.png", theme.."l_physlock_on.png")
	physlock:SetControl("physbrake")
	physlock:SetPressedStateData(ext, "physlock")
	layout:AddNewButton(physlock)

	local hads = TardisScreenButton:new(frame)
	hads:SetIsToggle(true)
	hads:SetImages(theme.."l_hads_off.png", theme.."l_hads_on.png")
	hads:SetControl("hads")
	hads:SetPressedStateData(ext, "hads")
	layout:AddNewButton(hads)

	local destination = TardisScreenButton:new(frame)
	destination:SetIsToggle(false)
	destination:SetImages(theme.."b_manualselect.png")
	destination:SetControl("destination")
	layout:AddNewButton(destination)

	local flightcontrol = TardisScreenButton:new(frame)
	flightcontrol:SetIsToggle(false)
	flightcontrol:SetImages(theme.."b_flightcontrol.png")
	flightcontrol:SetControl("flightcontrol")
	layout:AddNewButton(flightcontrol)

	layout:DrawButtons()

	layout.scroll_size = math.max(1, math.floor(layout:GetCols() / 2))
	layout.max_scroll = layout:GetMaxScrollX()
	layout.total_scroll = 0

	frame.Think = function()
		screen.left_arrow:SetVisible(true)
		screen.right_arrow:SetVisible(true)
		screen.right_arrow.DoClick = function()
			if layout.total_scroll <= layout.max_scroll
				and not screen.left_arrow:IsPressed()
				and not screen.right_arrow:IsPressed()
			then
				layout.total_scroll = layout.total_scroll + layout.scroll_size
				layout:ScrollButtons(-layout.scroll_size)
			end
		end
		screen.left_arrow.DoClick = function()
			if layout.total_scroll - layout.scroll_size >= 0
				and not screen.right_arrow:IsPressed()
				and not screen.left_arrow:IsPressed()
			then
				layout.total_scroll = layout.total_scroll - layout.scroll_size
				layout:ScrollButtons(layout.scroll_size)
			end
		end
	end

end

TARDIS:AddScreen("Console", {menu=false}, function(self,ext,int,frame,screen)
	if TARDIS:GetSetting("visual_gui_enabled")
	then
		new_virtual_console(self,ext,int,frame,screen)
	else
		old_virtual_console(self,ext,int,frame,screen)
	end
end)
