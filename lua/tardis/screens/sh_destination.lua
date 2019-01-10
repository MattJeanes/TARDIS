-- Destination

TARDIS:AddControl("destination",{
	func=function(self,ply)
		self:SelectDestination(ply, true)
	end,
	exterior=true,
	serveronly=true
})
if SERVER then
	util.AddNetworkString("TARDIS-ListDest")

	net.Receive("TARDIS-ListDest", function(len,ply)
		local pos = net.ReadVector()
		local ang = net.ReadAngle()
		local ext = net.ReadEntity()
		ext:SetDestination(pos,ang)
	end)
end
if SERVER then return end

TARDIS:AddScreen("Destination", {menu=false}, function(self,ext,int,frame,screen)
--[[	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Med")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Press to select destination")
	label:DoLayout()
]]	
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
			pos = Vector(x:GetText() or 0, y:GetText()or 0, z:GetText() or 0)
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
	list:SetPos( frame:GetWide()*0.26 - list:GetWide()*0.35, frame:GetTall()*0.5 - list:GetTall()*0.5)
	list:AddColumn("Name")
	local map = game.GetMap()
	if TARDIS.Locations[map] ~= nil then
		for k,v in pairs(TARDIS.Locations[map]) do
			list:AddLine(v.name)
			print(v.name)
		end
	end
	function list:OnRowSelected(i,row)
		pos = TARDIS.Locations[map][i].pos
		ang = TARDIS.Locations[map][i].ang
		updatetextinputs(pos,ang)
	end

	local confirm = vgui.Create("DButton",frame)
	confirm:SetSize( frame:GetWide()*0.1, frame:GetTall()*0.1 )
	confirm:SetPos(yaw:GetPos()-15,frame:GetTall()*0.9 - button:GetTall()*0.5)
	confirm:SetText("Confirm")
	confirm:SetFont("TARDIS-Default")
	function confirm:DoClick()
		local pos,ang = fetchtextinputs()
		if pos ~= false then
			net.Start("TARDIS-ListDest")
				net.WriteVector(pos)
				net.WriteAngle(ang)
				net.WriteEntity(ext)
			net.SendToServer()
			LocalPlayer():ChatPrint("Destination locked")
		else
			LocalPlayer():ChatPrint("No destination set")
		end
	end
end)