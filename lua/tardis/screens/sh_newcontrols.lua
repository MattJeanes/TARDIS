if SERVER then return end

TARDIS:AddScreen("New Controls", {menu=false}, function(self,ext,int,frame,screen)

	local background=vgui.Create("DImage", frame)
	
	background:SetImage("materials/vgui/backgrounds/1.jpg")
	background:SetSize( frame:GetWide(), frame:GetTall() )

	--frame:SetHTML("<p> aaa </p> <img src=\"https://i.gifer.com/embedded/download/Uzga.gif\">")
	--frame:SetVisible(true)
	--background:SetVisible(false)

	local fastreturn = TardisScreenButton:new(frame)
	fastreturn:SetSize( frame:GetWide()*0.25, frame:GetTall()*0.5 )
	fastreturn:SetPos(frame:GetWide()*0.7 - fastreturn:GetWide()*0.5,frame:GetTall()*0.5 - fastreturn:GetTall()*0.5)
	fastreturn:SetIsToggle(false)
	fastreturn:SetImages("materials/vgui/buttons/fastreturn_off.png", "materials/vgui/buttons/fastreturn_on.png")
	fastreturn.DoClick = function()
		TARDIS:Control("fastreturn")
	end

	local door = TardisScreenButton:new(frame)
	door:SetSize( frame:GetWide()*0.25, frame:GetTall()*0.5 )
	door:SetPos(frame:GetWide()*0.3 - door:GetWide()*0.5,frame:GetTall()*0.5 - door:GetTall()*0.5)
	door:SetIsToggle(true)
	door:SetToggle(ext:DoorOpen())
	door:SetImages("materials/vgui/buttons/door_closed.png", "materials/vgui/buttons/door_open.png")
	door.DoClick = function()
		TARDIS:Control("doorcontroller")
		door:SetToggle(ext:DoorOpen())
	end
	door.Think = function()
		door:SetToggle(ext:DoorOpen())
	end

end)
