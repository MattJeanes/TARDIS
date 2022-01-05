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

	local text_bar = vgui.Create( "DTextEntry3D2D", frame )
	text_bar.is3D2D = screen.is3D2D
	text_bar.sub3D2D = label:GetText()
	text_bar:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	text_bar:SetSize( frame:GetWide()*0.5, frame:GetTall()*0.1 )
	text_bar:SetPos(frame:GetWide()*0.5 - text_bar:GetWide()*0.5,frame:GetTall()*0.5 - text_bar:GetTall()*0.5)
	text_bar.OnEnter = function()
		ext:PlayMusic(text_bar:GetValue())
	end

	local playbutt=vgui.Create("DButton",frame)
	playbutt:SetSize( frame:GetWide()*0.2, text_bar:GetTall())
	playbutt:SetPos(text_bar:GetX() + text_bar:GetWide()*1.02, text_bar:GetY())
	playbutt:SetText("Play")
	playbutt:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	playbutt.DoClick = function()
		ext:PlayMusic(text_bar:GetValue())
	end

	local button11=vgui.Create("DButton",frame)
	button11:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	button11:SetPos(frame:GetWide()*0.8 - button11:GetWide()*0.5,frame:GetTall()*0.7 - button11:GetTall()*0.5)
	button11:SetText("11th Doctor's Theme")
	button11:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	button11.DoClick = function()
		text_bar:SetText("http://mattjeanes.com/data/tardis/eleven.mp3")
	end

	local button9=vgui.Create("DButton",frame)
	button9:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	button9:SetPos(frame:GetWide()*0.2 - button9:GetWide()*0.5,frame:GetTall()*0.7 - button9:GetTall()*0.5)
	button9:SetText("9th Doctor's Theme")
	button9:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	button9.DoClick = function()
		text_bar:SetText("http://mattjeanes.com/data/tardis/nine.mp3")
	end

	local button10=vgui.Create("DButton",frame)
	button10:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	button10:SetPos(frame:GetWide()*0.5 - button10:GetWide()*0.5,frame:GetTall()*0.7 - button10:GetTall()*0.5)
	button10:SetText("10th Doctor's Theme")
	button10:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	button10.DoClick = function()
		text_bar:SetText("http://mattjeanes.com/data/tardis/ten.mp3")
	end

	local stop=vgui.Create("DButton",frame)
	stop:SetVisible(false)
	stop:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	stop:SetPos(frame:GetWide()*0.5 - stop:GetWide()*0.5,frame:GetTall()*0.13 - stop:GetTall()*0.5)
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