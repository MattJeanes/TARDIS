-- Music

TARDIS:AddScreen("Music", {id="music", menu=false, order=10}, function(self,ext,int,frame,screen)
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont(TARDIS:GetScreenFont(screen, "Med"))
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Enter song URL (clientside only currently)")
	label:DoLayout()

	local text = vgui.Create( "DTextEntry3D2D", frame )
	text.is3D2D = screen.is3D2D
	text.sub3D2D = label:GetText()
	text:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	text:SetSize( frame:GetWide()*0.5, frame:GetTall()*0.1 )
	text:SetPos(frame:GetWide()*0.5 - text:GetWide()*0.5,frame:GetTall()*0.5 - text:GetTall()*0.5)
	text.OnEnter = function()
		ext:PlayMusic(text:GetValue())
	end
	
	local stop=vgui.Create("DButton",frame)
	stop:SetVisible(false)
	stop:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	stop:SetPos(frame:GetWide()*0.5 - stop:GetWide()*0.5,frame:GetTall()*0.7 - stop:GetTall()*0.5)
	stop:SetText("Stop")
	stop:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	stop.DoClick = function()
		ext:StopMusic()
	end
	
	frame.Think = function()
		if IsValid(ext.music) and ext.music:GetState()==GMOD_CHANNEL_PLAYING then
			if not stop:IsVisible() then
				stop:SetVisible(true)
			end
		elseif stop:IsVisible() then
			stop:SetVisible(false)
		end
	end
end)