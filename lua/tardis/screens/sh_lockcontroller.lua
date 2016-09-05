-- Lock controller

TARDIS:AddControl("lockcontroller",{
	func=function(self,ply)
		self:ToggleLocked()
	end,
	exterior=true,
	serveronly=true
})

if SERVER then return end

TARDIS:AddScreen("Lock controller", {intonly=true,menu=false}, function(self,ext,int,frame)
	local status = vgui.Create("DLabel",frame)
	status:SetTextColor(Color(0,0,0))
	status:SetFont("TARDIS-Large")
	status.DoLayout = function(self)
		status:SizeToContents()
		status:SetPos((frame:GetWide()*0.5)-(status:GetWide()*0.5),(frame:GetTall()*0.35)-(status:GetTall()*0.5))
	end
	status:DoLayout()

	local button = vgui.Create("DButton",frame)
	button.first=true
	button:SetFont("TARDIS-Default")
	button:SetSize(frame:GetWide()*0.3,frame:GetTall()*0.15)
	button:SetPos((frame:GetWide()*0.5)-(button:GetWide()*0.5),(frame:GetTall()*0.6)-(button:GetTall()*0.5))
	button.DoClick = function(button)
		TARDIS:Control("lockcontroller")
	end
	button.Think = function(button)
		if ext:Locking() then
			if not button:GetDisabled() then
				if ext:Locked() then
					status:SetText("The door is unlocking")
				else
					status:SetText("The door is locking")
				end
				status:DoLayout()
				button:SetDisabled(true)
			end
		elseif button:GetDisabled() then
			button:SetDisabled(false)
		elseif ext:Locked() and (not button.lock) or button.first then
			button.lock=true
			button:SetText("Unlock the door")
			status:SetText("The door is locked")
			status:DoLayout()
			if button.first then
				button.first=nil
			end
		elseif not ext:Locked() and button.lock or button.first then
			button.lock=false
			button:SetText("Lock the door")
			status:SetText("The door is unlocked")
			status:DoLayout()
			if button.first then
				button.first=nil
			end
		end
	end
end)