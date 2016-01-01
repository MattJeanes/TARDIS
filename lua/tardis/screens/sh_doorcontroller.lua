-- Door controller

TARDIS:AddControl("doorcontroller",{
	func=function(self,ply)
		self:ToggleDoor()
	end,
	exterior=true,
	serveronly=true
})

if SERVER then return end

TARDIS:AddScreen("Door controller", {intonly=true,menu=false}, function(self,ext,int,frame)
	local doorstatus = vgui.Create("DLabel",frame)
	doorstatus:SetTextColor(Color(0,0,0))
	doorstatus:SetFont("TARDIS-Large")
	doorstatus.DoLayout = function(self)
		doorstatus:SizeToContents()
		doorstatus:SetPos((frame:GetWide()*0.5)-(doorstatus:GetWide()*0.5),(frame:GetTall()*0.35)-(doorstatus:GetTall()*0.5))
	end
	doorstatus:DoLayout()

	local button = vgui.Create("DButton",frame)
	button.first=true
	button:SetFont("TARDIS-Default")
	button:SetSize(frame:GetWide()*0.3,frame:GetTall()*0.15)
	button:SetPos((frame:GetWide()*0.5)-(button:GetWide()*0.5),(frame:GetTall()*0.6)-(button:GetTall()*0.5))
	button.DoClick = function(button)
		TARDIS:Control("doorcontroller")
	end
	button.Think = function(button)
		if ext:DoorMoving() then
			if not button:GetDisabled() then
				if button.open then
					doorstatus:SetText("The door is closing")
				else
					doorstatus:SetText("The door is opening")
				end
				doorstatus:DoLayout()
				button:SetDisabled(true)
			end
		elseif button:GetDisabled() then
			button:SetDisabled(false)
		elseif ext:DoorOpen() and (not button.open) or button.first then
			button.open=true
			button:SetText("Close the door")
			doorstatus:SetText("The door is open")
			doorstatus:DoLayout()
			if button.first then
				button.first=nil
			end
		elseif not ext:DoorOpen() and button.open or button.first then
			button.open=false
			button:SetText("Open the door")
			doorstatus:SetText("The door is closed")
			doorstatus:DoLayout()
			if button.first then
				button.first=nil
			end
		end
	end
end)