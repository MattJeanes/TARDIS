-- Destination

TARDIS:AddControl("destination",{
	func=function(self,ply)
		self:SelectDestination(ply, true)
	end,
	exterior=true,
	serveronly=true
})

if SERVER then return end

TARDIS:AddScreen("Destination", {menu=false}, function(self,ext,int,frame,screen)
	
	if screen.is3D2D then
		local label = vgui.Create("DLabel",frame)
		label:SetTextColor(Color(0,0,0))
		label:SetFont("TARDIS-Med")
		label.DoLayout = function(self)
			label:SizeToContents()
			label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
		end
		label:SetText("Pop screen for full functionality")
		label:DoLayout()

		local button=vgui.Create("DButton",frame)
		button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1 )
		button:SetPos(frame:GetWide()*0.5 - button:GetWide()*0.5,frame:GetTall()*0.5 - button:GetTall()*0.5)
		button:SetText("Select Manually")
		button:SetFont("TARDIS-Default")
		button.DoClick = function()
			TARDIS:Control("destination")
			if TARDIS:HUDScreenOpen(ply) then TARDIS:RemoveHUDScreen() end
		end
		return
	end
	local button=vgui.Create("DButton",frame)
	button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1 )
	button:SetPos(frame:GetWide()*0.86 - button:GetWide()*0.5,frame:GetTall()*0.08 - button:GetTall()*0.5)
	button:SetText("Select Manually")
	button:SetFont("TARDIS-Default")
	button.DoClick = function()
		TARDIS:Control("destination")
		if TARDIS:HUDScreenOpen(ply) then TARDIS:RemoveHUDScreen() end
	end
	local btnx,btny = button:GetPos()
	local x = vgui.Create("DTextEntry",frame)
	x:SetPlaceholderText("x")
	x:SetPos(btnx*0.97,btny*5)
	local y = vgui.Create("DTextEntry",frame)
	y:SetPlaceholderText("y")
	y:SetPos(btnx*1.08,btny*5)
	local z = vgui.Create("DTextEntry",frame)
	z:SetPlaceholderText("z")
	z:SetPos(btnx*1.19,btny*5)


	local pitch = vgui.Create("DTextEntry",frame)
	pitch:SetPlaceholderText("Pitch")
	pitch:SetPos(btnx*0.97,btny*7)
	local yaw = vgui.Create("DTextEntry",frame)
	yaw:SetPlaceholderText("Yaw")
	yaw:SetPos(btnx*1.08,btny*7)
	local roll = vgui.Create("DTextEntry",frame)
	roll:SetPlaceholderText("Roll")
	roll:SetPos(btnx*1.19,btny*7)

	x:SetNumeric(true)
	y:SetNumeric(true)
	z:SetNumeric(true)
	pitch:SetNumeric(true)
	yaw:SetNumeric(true)
	roll:SetNumeric(true)

	local function updatetextinputs(pos,ang)
		pitch:SetText(ang.p)
		yaw:SetText(ang.y)
		roll:SetText(ang.r)
		x:SetText(pos.x)
		y:SetText(pos.y)
		z:SetText(pos.z)
	end
	local function fetchtextinputs()
		local pos = 0
		local ang = 0
		if x:GetText() ~= "" and y:GetText() ~= "" and z:GetText() ~= "" then
			pos = Vector(x:GetText() or 0, y:GetText() or 0, z:GetText() or 0)
		end
		if pitch:GetText() ~= "" and yaw:GetText() ~= "" and roll:GetText() ~= "" then
			ang = Angle(pitch:GetText() or 0, yaw:GetText() or 0, roll:GetText() or 0)
		end
		if pos ~= 0 and ang ~= 0 then
			return pos,ang
		else
			return false,false
		end
	end
	if ext:GetData("demat-pos") and ext:GetData("demat-ang") then
		updatetextinputs(ext:GetData("demat-pos"), ext:GetData("demat-ang"))
	end



	local list = vgui.Create("DListView",frame)
	list:SetSize( frame:GetWide()*0.7, frame:GetTall()*0.95 )
	list:SetPos( frame:GetWide()*0.26 - list:GetWide()*0.35, frame:GetTall()*0.5 - list:GetTall()*0.5 )
	list:AddColumn("Name")
	local map = game.GetMap()
	local function updatelist()
		list:Clear()
		if TARDIS.Locations[map] ~= nil then
			for k,v in pairs(TARDIS.Locations[map]) do
				list:AddLine(v.name)
			end
		end
	end
	updatelist()
	function list:OnRowSelected(i,row)
		pos = TARDIS.Locations[map][i].pos
		ang = TARDIS.Locations[map][i].ang
		updatetextinputs(pos,ang)
	end

	local new = vgui.Create("DButton", frame)
	new:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
	new:SetPos(pitch:GetPos()+5,frame:GetTall()*0.35 - button:GetTall()*0.5)
	new:SetText("New")
	new:SetFont("TARDIS-Default")
	function new:DoClick()
		local name = ""
		local pos = Vector(0,0,0)
		local ang = Angle(0,0,0)
		Derma_StringRequest("New Location",
		"Enter the name for the new location",
		"New Location", 
		function(text)
			name = text
			Derma_Query(
				"Use current TARDIS position and rotation?",
				"New Location",
				"Yes",
				function() 
						pos = ext:GetPos() 
						ang = ext:GetAngles() 
						TARDIS:AddLocation(pos,ang,name,map) 
						updatelist() 
				end,
				"No", 
				function() 
					TARDIS:AddLocation(pos,ang,name,map)
					updatelist() 
				end)
		end)
	end
	local pendingchanges = false

	local function ShowLocationDetails(name,pos,ang,index)
		if name == nil or pos == nil or ang == nil then return end
		local details = vgui.Create("DFrame")
		local width=(ScrW()/5)
		local height=(ScrH()/4)
		details:SetSize(width,height)
		details:SetPos( ScrW()/2 - width/2, ScrH()/2.3 - height/2 )
		details:Center()
		details:SetTitle("Location Details")
		details:SetSkin("TARDIS")
		details:MakePopup()

		local panel = vgui.Create("DPanel", details)
		panel:Dock(FILL)
		panel:DockMargin(0,0,0,0)

		local namelabel = vgui.Create("DLabel", panel)
		namelabel:Dock(TOP)
		namelabel:DockMargin(5,5,0,0)
		namelabel:SetFont("TARDIS-Default")
		namelabel:SetTextColor(Color(21,21,21))
		namelabel:SetText("Location Name")

		local namebox = vgui.Create("DTextEntry", panel)
		namebox:Dock(TOP)
		namebox:DockMargin(5,5,5,0)

		local coords = vgui.Create("DLabel", panel)
		coords:Dock(TOP)
		coords:DockMargin(5,5,0,0)
		coords:SetFont("TARDIS-Default")
		coords:SetTextColor(Color(21,21,21))
		coords:SetText("Coordinates (X Y Z - Pitch Yaw Roll)")

		local coordspanel = vgui.Create("DPanel", panel)
		coordspanel:SetTall(30)
		coordspanel:Dock(TOP)
		coordspanel:DockMargin(5,5,5,0)

		local x = vgui.Create("DTextEntry", coordspanel)
		x:Dock(LEFT)
		x:DockMargin(5,5,5,5)
		x:SetWide(width/3.7)
		local y = vgui.Create("DTextEntry", coordspanel)
		y:Dock(LEFT)
		y:DockMargin(5,5,5,5)
		y:SetWide(width/3.7)
		local z = vgui.Create("DTextEntry", coordspanel)
		z:Dock(LEFT)
		z:DockMargin(5,5,5,5)
		z:SetWide(width/3.7)

		local anglepanel = vgui.Create("DPanel", panel)
		anglepanel:SetTall(30)
		anglepanel:Dock(TOP)
		anglepanel:DockMargin(5,5,5,0)

		local pitch = vgui.Create("DTextEntry", anglepanel)
		pitch:Dock(LEFT)
		pitch:DockMargin(5,5,5,5)
		pitch:SetWide(width/3.7)
		local yaw = vgui.Create("DTextEntry", anglepanel)
		yaw:Dock(LEFT)
		yaw:DockMargin(5,5,5,5)
		yaw:SetWide(width/3.7)
		local roll = vgui.Create("DTextEntry", anglepanel)
		roll:Dock(LEFT)
		roll:DockMargin(5,5,5,5)
		roll:SetWide(width/3.7)
		pitch:SetText(ang.p)
		yaw:SetText(ang.y)
		roll:SetText(ang.r)
		x:SetText(pos.x)
		y:SetText(pos.y)
		z:SetText(pos.z)
		namebox:SetText(name)

		local map = game.GetMap()
		local function fetchtextinputs()
			local pos = 0
			local ang = 0
			local name = namebox:GetText()
			if x:GetText() ~= "" and y:GetText() ~= "" and z:GetText() ~= "" then
				pos = Vector(x:GetText() or 0, y:GetText() or 0, z:GetText() or 0)
			end
			if pitch:GetText() ~= "" and yaw:GetText() ~= "" and roll:GetText() ~= "" then
				ang = Angle(pitch:GetText() or 0, yaw:GetText() or 0, roll:GetText() or 0)
			end
			if pos ~= 0 and ang ~= 0 then
				return pos,ang,name
			else
				return false,false,false
			end
		end

		local savebtn = vgui.Create("DButton", panel)
		savebtn:Dock(TOP)
		savebtn:DockMargin(5,5,5,0)
		savebtn:SetText("Save")
		function savebtn:DoClick()
			local pos,ang,name = fetchtextinputs()
			if pos ~= nil then
				pendingchanges = true
				TARDIS:UpdateLocation(pos,ang,name,map,index)
				updatelist()
				details:Close()
			end
		end
	end

	local edit = vgui.Create("DButton", frame)
	edit:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
	edit:SetPos(yaw:GetPos()+5,frame:GetTall()*0.35 - button:GetTall()*0.5)
	edit:SetText("Edit")
	edit:SetFont("TARDIS-Default")
	function edit:DoClick()
		if list:GetSelectedLine() == nil then return end
		local index = list:GetSelectedLine()
		local name = TARDIS.Locations[map][index].name
		print(name)
		local pos, ang = fetchtextinputs()
		ShowLocationDetails(name,pos,ang,index)
	end

	local remove = vgui.Create("DButton", frame)
	remove:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
	remove:SetPos(roll:GetPos()+5,frame:GetTall()*0.35 - button:GetTall()*0.5)
	remove:SetText("Delete")
	remove:SetFont("TARDIS-Default")
	function remove:DoClick()
		local index = list:GetSelectedLine()
		if not index then return end
		Derma_Query("This will remove the selected location PERMANENTLY! Are you sure?","Remove Location","Yes",
		function() TARDIS:RemoveLocation(map,index) updatelist() pendingchanges = true end,
		"No")
	end
	local save = vgui.Create("DButton", frame)
	save:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
	save:SetPos(frame:GetWide()*0.82 - save:GetWide()*0.5, frame:GetTall()*0.5 - save:GetTall()*0.5)
	save:SetText("Save")
	save:SetFont("TARDIS-Default")
	function save:DoClick()
		TARDIS:SaveLocations()
		pendingchanges = false
		LocalPlayer():ChatPrint("Locations Saved")
	end
	function save:Think()
		if pendingchanges then
			self:SetText("Save*")
		else
			self:SetText("Save")
		end
	end
	local load = vgui.Create("DButton", frame)
	load:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
	load:SetPos(frame:GetWide()*0.9 - load:GetWide()*0.5, frame:GetTall()*0.5 - load:GetTall()*0.5)
	load:SetText("Load")
	load:SetFont("TARDIS-Default")
	function load:DoClick()
		TARDIS:LoadLocations()
		updatelist()
		pendingchanges = false
		LocalPlayer():ChatPrint("Locations Loaded")
	end

	local confirm = vgui.Create("DButton",frame)
	confirm:SetSize( frame:GetWide()*0.1, frame:GetTall()*0.1 )
	confirm:SetPos(yaw:GetPos()-15,frame:GetTall()*0.9 - button:GetTall()*0.5)
	confirm:SetText("Set")
	confirm:SetFont("TARDIS-Default")
	function confirm:DoClick()
		local pos,ang = fetchtextinputs()
		if pos ~= false then
			ext:SendMessage("destination-demat", function()
				net.WriteVector(pos)
				net.WriteAngle(ang)
				if TARDIS:GetSetting("dest-onsetdemat") then
					if TARDIS:HUDScreenOpen(ply) then
						TARDIS:RemoveHUDScreen()
					end
				end
			end)
		else
			LocalPlayer():ChatPrint("No destination set")
		end
	end
end)