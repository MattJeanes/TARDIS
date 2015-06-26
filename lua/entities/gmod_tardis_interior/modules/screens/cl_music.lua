-- Music

function ENT:StopMusic()
	if IsValid(self.music) then
		self.music:Stop()
		self.music=nil
	end
end

function ENT:ResolveMusicURL(url)
	if url:find("youtu.be") or url:find("youtube.com") then
		if url:find("youtu.be") then
			local explode=string.Explode("/",url)
			url="https://www.youtube.com/watch?v="..explode[#explode]
		end
		http.Fetch("http://youtubeinmp3.com/fetch/?api=advanced&format=JSON&video="..url,
			function(body,len,headers,code)
				if code==200 then
					local tbl=util.JSONToTable(body)
					if tbl then
						self:PlayMusic(tbl.link,true)
					else
						LocalPlayer():ChatPrint("ERROR: Failed to resolve url (API failed, try again)")
					end
				else
					LocalPlayer():ChatPrint("ERROR: Failed to resolve url (HTTP "..code..")")
				end
			end,
			function(err)
				LocalPlayer():ChatPrint("ERROR: Failed to resolve url ("..err..")")
			end
		)
	else
		return url
	end
end

function ENT:PlayMusic(url,resolved)
	if not resolved then
		url=self:ResolveMusicURL(url)
	end
	if url then
		self:StopMusic()
		sound.PlayURL(url, "", function(station,errorid,errorname)
			if station then
				station:SetVolume(1)
				station:Play()
				self.music=station
			else
				LocalPlayer():ChatPrint("ERROR: Failed to load song (Error ID: "..errorid..", "..errorname..")")
			end
		end)
	end
end

ENT:AddHook("OnRemove", "Music", function(self)
	self:StopMusic()
end)

TARDIS_AddScreen("Music", function(self,frame,screen)
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont("TARDIS-Med")
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Enter song URL (clientside only currently)")
	label:DoLayout()

	local text = vgui.Create( "DTextEntry3D2D", frame )
	text.is3D2D = screen.is3D2D
	text.sub3D2D = label:GetText()
	text:SetFont("TARDIS-Default")
	text:SetPos( self.screengap, self.screengap )
	text:SetSize( frame:GetWide()*0.5, frame:GetTall()*0.1 )
	text:SetPos(frame:GetWide()*0.5 - text:GetWide()*0.5,frame:GetTall()*0.5 - text:GetTall()*0.5)
	text.OnEnter = function()
		self:PlayMusic(text:GetValue())
	end
	
	local stop=vgui.Create("DButton",frame)
	stop:SetVisible(false)
	stop:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.15 )
	stop:SetPos(frame:GetWide()*0.5 - stop:GetWide()*0.5,frame:GetTall()*0.7 - stop:GetTall()*0.5)
	stop:SetText("Stop")
	stop:SetFont("TARDIS-Default")
	stop.DoClick = function()
		self:StopMusic()
	end
	
	frame.Think = function()
		if IsValid(self.music) and self.music:GetState()==GMOD_CHANNEL_PLAYING then
			if not stop:IsVisible() then
				stop:SetVisible(true)
			end
		elseif stop:IsVisible() then
			stop:SetVisible(false)
		end
	end
end)