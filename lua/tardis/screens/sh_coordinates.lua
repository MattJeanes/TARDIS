-- Destination

TARDIS:AddControl({
	id = "coordinates",
	ext_func=function(self,ply)
		TARDIS:PopToScreen("Destination", ply)
	end,
	serveronly = true,
	screen_button = false, -- already added as a screen
	tip_text = "Coordinates",
})

if SERVER then return end

TARDIS:AddScreen("Destination", {id="coordinates", text="Coordinates", menu=false, order=2, popuponly=true}, function(self,ext,int,frame,screen)
	local button=vgui.Create("DButton",frame)
	button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1 )
	button:SetPos(frame:GetWide()*0.86 - button:GetWide()*0.5,frame:GetTall()*0.08 - button:GetTall()*0.5)
	button:SetText("Select Manually")
	button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
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

	local namebox = vgui.Create("DTextEntry", frame)
	namebox:SetPos(pitch:GetPos()+5,frame:GetTall()*0.33 - button:GetTall()*0.5)
	namebox:SetWide(frame:GetWide()*0.237)
	namebox:SetPlaceholderText("Name")

	local function updatetextinputs(pos,ang,name)
		pitch:SetText(ang.p)
		yaw:SetText(ang.y)
		roll:SetText(ang.r)
		x:SetText(pos.x)
		y:SetText(pos.y)
		z:SetText(pos.z)
		if name then namebox:SetText(name) end
	end
	local function fetchtextinputs()
		local pos = 0
		local ang = 0
		local name = ""
		if x:GetText() ~= "" and y:GetText() ~= "" and z:GetText() ~= "" then
			pos = Vector(x:GetText() or 0, y:GetText() or 0, z:GetText() or 0)
		end
		if pitch:GetText() ~= "" and yaw:GetText() ~= "" and roll:GetText() ~= "" then
			ang = Angle(pitch:GetText() or 0, yaw:GetText() or 0, roll:GetText() or 0)
		end
		if namebox:GetText() ~= "" then
			name = namebox:GetText()
		end
		if name == "" then name = "Unnamed" end
		return pos,ang,name
	end
	if ext:GetData("demat-pos") and ext:GetData("demat-ang") then
		updatetextinputs(ext:GetData("demat-pos"), ext:GetData("demat-ang"),"Current Set Destination")
		namebox:SetEnabled(false)
	end

	local pendingchanges = false

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
		name = TARDIS.Locations[map][i].name
		updatetextinputs(pos,ang,name)
		namebox:SetEnabled(true)
	end
	list:SetMultiSelect(false)

	local gpos = vgui.Create("DButton", frame)
	gpos:SetSize( frame:GetWide()*0.247, frame:GetTall()*0.1 )
	gpos:SetPos(pitch:GetPos(),frame:GetTall()*0.4 - button:GetTall()*0.5)
	gpos:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	gpos:SetText("Get Current Position")

	function gpos:DoClick()
		updatetextinputs(ext:GetPos(), ext:GetAngles())
	end

	local new = vgui.Create("DButton", frame)
	new:SetSize( frame:GetWide()*0.08, frame:GetTall()*0.1 )
	new:SetPos(pitch:GetPos(),frame:GetTall()*0.52 - button:GetTall()*0.5)
	new:SetText("New")
	new:SetFont(TARDIS:GetScreenFont(screen, "Default"))
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
				"Use current TARDIS position and rotation?\nSelecting 'No' will use the information on the inputs.",
				"New Location",
				"Yes",
				function() 
						pos = ext:GetPos() 
						ang = ext:GetAngles() 
						if name == "" then name = "Unnamed" end
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

	local edit = vgui.Create("DButton", frame)
	edit:SetSize( frame:GetWide()*0.08, frame:GetTall()*0.1 )
	edit:SetPos(yaw:GetPos(),frame:GetTall()*0.52 - button:GetTall()*0.5)
	edit:SetText("Update")
	edit:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	edit:SetEnabled(false)
	function edit:DoClick()
		pendingchanges = true
		local pos,ang,name = fetchtextinputs()
		local index = list:GetSelectedLine()
		if not index then return end
		TARDIS:UpdateLocation(pos,ang,name,map,index)
		updatelist()
	end
	function edit:Think()
		if list:GetSelectedLine() ~= nil then
			if self:IsEnabled() then return end
			self:SetEnabled(true)
		elseif self:IsEnabled() then
			self:SetEnabled(false)
		end
	end

	local remove = vgui.Create("DButton", frame)
	remove:SetSize( frame:GetWide()*0.08, frame:GetTall()*0.1 )
	remove:SetPos(roll:GetPos(),frame:GetTall()*0.52 - button:GetTall()*0.5)
	remove:SetText("Delete")
	remove:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	function remove:DoClick()
		local index = list:GetSelectedLine()
		if not index then return end
		Derma_Query("This will remove the selected location PERMANENTLY! Are you sure?","Remove Location","Yes",
		function() TARDIS:RemoveLocation(map,index) updatelist() pendingchanges = true end,
		"No")
	end
	function remove:Think()
		if list:GetSelectedLine() ~= nil then
			if self:IsEnabled() then return end
			self:SetEnabled(true)
		elseif self:IsEnabled() then
			self:SetEnabled(false)
		end
	end

	local save = vgui.Create("DButton", frame)
	save:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
	save:SetPos(frame:GetWide()*0.82 - save:GetWide()*0.5, frame:GetTall()*0.64 - save:GetTall()*0.5)
	save:SetText("Save")
	save:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	function save:DoClick()
		TARDIS:SaveLocations()
		pendingchanges = false
        TARDIS:Message(LocalPlayer(), "Locations Saved")
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
	load:SetPos(frame:GetWide()*0.9 - load:GetWide()*0.5, frame:GetTall()*0.64 - load:GetTall()*0.5)
	load:SetText("Load")
	load:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	function load:DoClick()
		TARDIS:LoadLocations()
		updatelist()
		pendingchanges = false
        TARDIS:Message(LocalPlayer(), "Locations Loaded")
	end

	local confirm = vgui.Create("DButton",frame)
	confirm:SetSize( frame:GetWide()*0.1, frame:GetTall()*0.1 )
	confirm:SetPos(yaw:GetPos()-15,frame:GetTall()*0.9 - button:GetTall()*0.5)
	confirm:SetText("Set")
	confirm:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	function confirm:DoClick()
		local pos,ang = fetchtextinputs()
		if pos ~= nil then
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
            TARDIS:Message(LocalPlayer(), "No destination set")
		end
	end

	function frame:OnCloseScreen()
		local result = true
		if not pendingchanges then return end
		Derma_Query("You have unsaved changes, would you like to save them?",
		"Pending changes",
		"Yes",
		function() 
			TARDIS:SaveLocations() 
			pendingchanges = false
			TARDIS:RemoveHUDScreen()
		end,
		"No",
		function() 
			pendingchanges = false
			TARDIS:RemoveHUDScreen()
		end,
		"Cancel",
		function() 

		end
		)
		return false;
	end

end)