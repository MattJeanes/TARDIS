include('shared.lua')

function ENT:Draw()
	if LocalPlayer().tardis==self:GetNWEntity("TARDIS", NULL) and LocalPlayer().tardis_viewmode and not LocalPlayer().tardis_render then
		self:DrawModel()
	end
end

net.Receive("TARDISInt-Locations-GUI", function()
	local interior=net.ReadEntity()
	local tardis=net.ReadEntity()	
	local typewriter=net.ReadEntity()	
	local locations={}
	local map=game.GetMap()
	local selected
	local selected2
	local changed=false
	
	local function TransmitCoordinates()
		local pos=selected.pos
		local ang=selected.ang
		if IsValid(interior) and IsValid(tardis) and (not tardis.moving or tardis.invortex) and pos and ang then
			net.Start("TARDISInt-Locations-Send")
				net.WriteEntity(interior)
				net.WriteEntity(tardis)
				net.WriteEntity(typewriter)
				net.WriteFloat(pos.x)
				net.WriteFloat(pos.y)
				net.WriteFloat(pos.z)
				net.WriteFloat(ang.p)
				net.WriteFloat(ang.y)
				net.WriteFloat(ang.r)
			net.SendToServer()
			return true
		else
			return false
		end
	end
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 415,300 )
	window:Center()
	window:SetTitle( "TARDIS Locations Menu" )
	window:MakePopup()
	
	local label = vgui.Create( "DLabel", window )
	label:SetPos(140,25) // Position
	label:SetColor(Color(255,255,255,255)) // Color
	label:SetFont("Trebuchet24")
	label:SetText("Vector") // Text
	label:SizeToContents() // make the control the same size as the text.
	
	local vec1 = vgui.Create( "DTextEntry", window )	-- create the form as a child of frame
	vec1:SetPos( 140, 55 )
	vec1:SetSize( 85, 20 )
	vec1:SetText( "X" )
	vec1.OnGetFocus = function( self)
		if self:GetValue()=="X" then
			self:SetText("")
		end
	end
	vec1.OnLoseFocus = function( self)
		if self:GetValue()=="" then
			self:SetText("X")
		else
			self:OnEnter()
		end
	end
	vec1.OnEnter = function( self )
		local val=self:GetValue()
		if selected and tonumber(self:GetValue()) then
			selected.pos.x=tonumber(self:GetValue())
			changed=true
		end
	end
	
	local vec2 = vgui.Create( "DTextEntry", window )	-- create the form as a child of frame
	vec2:SetPos( 230, 55 )
	vec2:SetSize( 85, 20 )
	vec2:SetText( "Y" )
	vec2.OnGetFocus = function( self)
		if self:GetValue()=="Y" then
			self:SetText("")
		end
	end
	vec2.OnLoseFocus = function( self)
		if self:GetValue()=="" then
			self:SetText("Y")
		else
			self:OnEnter()
		end
	end
	vec2.OnEnter = function( self )
		local val=self:GetValue()
		if selected and tonumber(self:GetValue()) then
			selected.pos.y=tonumber(self:GetValue())
			changed=true
		end
	end
	
	local vec3 = vgui.Create( "DTextEntry", window )	-- create the form as a child of frame
	vec3:SetPos( 320, 55 )
	vec3:SetSize( 85, 20 )
	vec3:SetText( "Z" )
	vec3.OnGetFocus = function( self)
		if self:GetValue()=="Z" then
			self:SetText("")
		end
	end
	vec3.OnLoseFocus = function( self)
		if self:GetValue()=="" then
			self:SetText("Z")
		else
			self:OnEnter()
		end
	end
	vec3.OnEnter = function( self )
		local val=self:GetValue()
		if selected and tonumber(self:GetValue()) then
			selected.pos.z=tonumber(self:GetValue())
			changed=true
		end
	end
	
	local label = vgui.Create( "DLabel", window )
	label:SetPos(140,75) // Position
	label:SetColor(Color(255,255,255,255)) // Color
	label:SetFont("Trebuchet24")
	label:SetText("Angle") // Text
	label:SizeToContents() // make the control the same size as the text.
	
	local ang1 = vgui.Create( "DTextEntry", window )	-- create the form as a child of frame
	ang1:SetPos( 140, 105 )
	ang1:SetSize( 85, 20 )
	ang1:SetText( "Pitch" )
	ang1.OnGetFocus = function( self)
		if self:GetValue()=="Pitch" then
			self:SetText("")
		end
	end
	ang1.OnLoseFocus = function( self)
		if self:GetValue()=="" then
			self:SetText("Pitch")
		else
			self:OnEnter()
		end
	end
	ang1.OnEnter = function( self )
		local val=self:GetValue()
		if selected and tonumber(self:GetValue()) then
			selected.ang.p=tonumber(self:GetValue())
			changed=true
		end
	end
	
	local ang2 = vgui.Create( "DTextEntry", window )	-- create the form as a child of frame
	ang2:SetPos( 230, 105 )
	ang2:SetSize( 85, 20 )
	ang2:SetText( "Yaw" )
	ang2.OnGetFocus = function( self)
		if self:GetValue()=="Yaw" then
			self:SetText("")
		end
	end
	ang2.OnLoseFocus = function( self)
		if self:GetValue()=="" then
			self:SetText("Yaw")
		else
			self:OnEnter()
		end
	end
	ang2.OnEnter = function( self )
		local val=self:GetValue()
		if selected and tonumber(self:GetValue()) then
			selected.ang.y=tonumber(self:GetValue())
			changed=true
		end
	end
	
	local ang3 = vgui.Create( "DTextEntry", window )	-- create the form as a child of frame
	ang3:SetPos( 320, 105 )
	ang3:SetSize( 85, 20 )
	ang3:SetText( "Roll" )
	ang3.OnGetFocus = function( self)
		if self:GetValue()=="Roll" then
			self:SetText("")
		end
	end
	ang3.OnLoseFocus = function( self)
		if self:GetValue()=="" then
			self:SetText("Roll")
		else
			self:OnEnter()
		end
	end
	ang3.OnEnter = function( self )
		local val=self:GetValue()
		if selected and tonumber(self:GetValue()) then
			selected.ang.r=tonumber(self:GetValue())
			changed=true
		end
	end
	
	local function UpdateTextBoxes()
		if selected then
			local vec=selected.pos
			local ang=selected.ang
			if vec and ang then
				vec1:SetText(vec.x)
				vec2:SetText(vec.y)
				vec3:SetText(vec.z)
				ang1:SetText(ang.p)
				ang2:SetText(ang.y)
				ang3:SetText(ang.r)
			end
		else
			vec1:SetText("X")
			vec2:SetText("Y")
			vec3:SetText("Z")
			ang1:SetText("Pitch")
			ang2:SetText("Yaw")
			ang3:SetText("Roll")
		end
	end
	
	local listview = vgui.Create( "DListView", window )
	listview:SetPos(10,30)
	listview:SetSize(125,260)
	listview:SetMultiSelect( false )
	listview:AddColumn( "Saved Locations" )
	listview.OnClickLine = function(self,line)
		local name=line:GetValue(1)
		self:ClearSelection()
		self:SelectItem(line)
		for k,v in pairs(locations[map]) do
			if v.name==name then
				selected=v
				selected2=line
				UpdateTextBoxes()
			end
		end
	end	
	
	local function Reload()
		listview:ClearSelection()
		listview:Clear()
		selected=nil
		selected2=nil
		for k,v in pairs(locations[map]) do
			listview:AddLine( v.name )
		end
		UpdateTextBoxes()
	end
	
	local function Load(msg)
		locations={}
		locations[map]={}
		if file.Exists("tardis_locations.txt", "DATA") then
			locations=von.deserialize(file.Read("tardis_locations.txt"))
			if not locations[map] then
				locations[map]={}
			end
			if msg then
				LocalPlayer():ChatPrint("Locations loaded.")
			end
		end
		Reload()
	end
	Load(false)
	
	local function Save(msg)
		file.Write("tardis_locations.txt", von.serialize(locations))
		changed=false
		if msg then
			LocalPlayer():ChatPrint("Locations saved.")
		end
	end
	
	local function New()
		Derma_StringRequest(
			"New Location",
			"Please enter a name for the new location",
			"",
			function(name)
				local exists=false
				for k,v in pairs(locations[map]) do
					if v.name==name then
						exists=true
						break
					end
				end
				if string.len(name)==0 then
					LocalPlayer():ChatPrint("Invalid name.")
				elseif exists then
					LocalPlayer():ChatPrint("Name already in use.")
				else
					local pos=Vector(0,0,0)
					local ang=Angle(0,0,0)
					Derma_Query(
						"Would you like to use current TARDIS position/angle?",
						"Use Current Pos?",
						"Yes",
						function()
							if IsValid(tardis) then
								pos=tardis:GetPos()
								ang=tardis:GetAngles()
							else
								LocalPlayer():ChatPrint("Error, TARDIS does not exist.")
							end
							table.insert(locations[map], {name=name, pos=pos, ang=ang})
							Reload()
							changed=true
						end,
						"No",
						function()
							table.insert(locations[map], {name=name, pos=pos, ang=ang})
							Reload()
							changed=true
						end
					)
				end
			end,
			function(name) end
		)
	end
	
	local function Rename(location,line)
		Derma_StringRequest(
			"New Location",
			"Please enter a new name for the location",
			location.name,
			function(name)
				local exists=false
				for k,v in pairs(locations[map]) do
					if v.name==name then
						exists=true
						break
					end
				end
				if string.len(name)==0 then
					LocalPlayer():ChatPrint("Invalid name.")
				elseif exists then
					LocalPlayer():ChatPrint("Name already in use.")
				else
					location.name=name
					Reload()
					changed=true
				end
			end,
			function(name) end
		)
	end
	
	local function Delete(location)
		for k,v in pairs(locations[map]) do
			if v.name==location.name then
				table.remove(locations[map],k)
				Reload()
				changed=true
			end
		end
	end
	
	local function Clear()
		Derma_Query(
			"Are you sure you want to clear this maps stored location data?",
			"Clear Data",
			"Yes",
			function()
				locations[map]={}
				Reload()
				LocalPlayer():ChatPrint("Map location data cleared.")
				changed=true
			end,
			"No",
			function()
			end
		)
	end
	
	local label = vgui.Create( "DLabel", window )
	label:SetPos(140,130) // Position
	label:SetColor(Color(255,255,255,255)) // Color
	label:SetFont("Trebuchet24")
	label:SetText("Location") // Text
	label:SizeToContents() // make the control the same size as the text.
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 140, 160 )
	button:SetText( "New" )
	button.DoClick = function( button )
		New()
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 230, 160 )
	button:SetText( "Rename" )
	button.DoClick = function( button )
		if selected then
			Rename(selected,selected2)
		else
			LocalPlayer():ChatPrint("No location selected.")
		end
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 320, 160 )
	button:SetText( "Delete" )
	button.DoClick = function( button )
		if selected then
			Delete(selected)
		else
			LocalPlayer():ChatPrint("No location selected.")
		end
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 140, 195 )
	button:SetText( "Upload Pos/Ang" )
	button.DoClick = function( button )
		if selected then
			local success=TransmitCoordinates()
			if success then
				window:Close()
			else
				LocalPlayer():ChatPrint("Error, TARDIS may already be teleporting.")
			end
		else
			LocalPlayer():ChatPrint("No location selected.")
		end
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 230, 195 )
	button:SetText( "Get Pos/Ang" )
	button.DoClick = function( button )
		if selected then
			selected.pos=tardis:GetPos()
			selected.ang=tardis:GetAngles()
			UpdateTextBoxes()
			changed=true
		else
			LocalPlayer():ChatPrint("No location selected.")
		end
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 320, 195 )
	button:SetText( "Reset" )
	button.DoClick = function( button )
		if selected then
			selected.pos=Vector(0,0,0)
			selected.ang=Angle(0,0,0)
			UpdateTextBoxes()
			changed=true
		else
			LocalPlayer():ChatPrint("No location selected.")
		end
	end
	
	local label = vgui.Create( "DLabel", window )
	label:SetPos(140,230) // Position
	label:SetColor(Color(255,255,255,255)) // Color
	label:SetFont("Trebuchet24")
	label:SetText("Data") // Text
	label:SizeToContents() // make the control the same size as the text.
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 140, 260 )
	button:SetText( "Clear Data" )
	button.DoClick = function( button )
		Clear()
	end
	
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 230, 260 )
	button:SetText( "Load Data" )
	button.DoClick = function( button )
		Load(true)
	end
 
	local button = vgui.Create( "DButton", window )
	button:SetSize( 85, 30 )
	button:SetPos( 320, 260 )
	button:SetText( "Save Data" )
	button.DoClick = function( button )
		Save(true)
	end
	
	local closefunc=window.Close
	window.Close=function(self)
		if changed then
			Derma_Query(
				"Do you wish to save your changes?",
				"Save Data",
				"Yes",
				function()
					Save(true)
					closefunc(self)
				end,
				"No",
				function()
					closefunc(self)
				end,
				"Cancel",
				function()
					
				end
			)
		else
			closefunc(self)
		end
	end
end)

function ENT:Think()
	if LocalPlayer():GetEyeTraceNoCursor().Entity==self and LocalPlayer():EyePos():Distance(self:GetPos())<60 then
		if tobool(GetConVarNumber("tardisint_tooltip"))==true then
			AddWorldTip( self:EntIndex(), "Programmable Flight Mode", 0.5, self:GetPos(), self.Entity  )
		end
		effects.halo.Add( {self}, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )
	end
end