-- Test screens

TARDIS_AddScreen("Door controller", function(self,main)
	local frame = vgui.Create("DPanel",main)
	frame:SetVisible(false)
	frame:SetSize(main:GetSize())
	frame:SetPos(0,0)

	local interface = vgui.Create("DLabel",frame)
	interface:SetTextColor(Color(0,0,0))
	interface:SetFont("TARDIS-Large")
	interface.DoLayout = function(self)
		interface:SizeToContents()
		interface:SetPos((frame:GetWide()*0.5)-(interface:GetWide()*0.5),(frame:GetTall()*0.3)-(interface:GetTall()*0.5))
	end
	interface:SetText("Door controller")
	interface:DoLayout()

	local doorstatus = vgui.Create("DLabel",frame)
	doorstatus:SetTextColor(Color(0,0,0))
	doorstatus:SetFont("DermaLarge")
	doorstatus.DoLayout = function(self)
		doorstatus:SizeToContents()
		doorstatus:SetPos((frame:GetWide()*0.5)-(doorstatus:GetWide()*0.5),(frame:GetTall()*0.5)-(doorstatus:GetTall()*0.5))
	end
	doorstatus:DoLayout()

	local button = vgui.Create("DButton",frame)
	button.first=true
	button:SetSize(200,30)
	button:SetPos((frame:GetWide()*0.5)-(button:GetWide()*0.5),(frame:GetTall()*0.7)-(button:GetTall()*0.5))
	button.DoClick = function(button)
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
			ext:Control("toggledoor")
		end
	end
	button.Think = function(button)
		local ext=self:GetNetEnt("exterior")
		if IsValid(ext) then
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
	end
	
	return frame
end)


TARDIS_AddScreen("Test", function(self,main)
	local frame = vgui.Create("DPanel",main)
	frame:SetVisible(false)
	frame:SetSize(main:GetSize())
	frame:SetPos(0,0)

	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Large")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.15)-(label:GetTall()*0.5))
	end
	label:SetText("Test Menu")
	label:DoLayout()
	
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("DermaLarge")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Try the menu button")
	label:DoLayout()
	
	local sprite = vgui.Create( "DSprite",frame )
	sprite:SetMaterial( Material( "icon16/emoticon_smile.png" ) )
	sprite:SetSize( 150, 150 )
	sprite:SetPos(frame:GetWide()/2,(frame:GetTall()/2)+(sprite:GetTall()*0.25))
	
	return frame
end)