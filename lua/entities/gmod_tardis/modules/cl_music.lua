-- Music

TARDIS:AddSetting({
	id="music-enabled",
	name="Enabled",
	desc="Whether music is played through the screens or not",
	section="Music",
	value=true,
	type="bool",
	option=true
})
TARDIS:AddSetting({
	id="music-volume",
	name="Volume",
	desc="The volume of the music played through the screens",
	section="Music",
	value=100,
	type="number",
	min=0,
	max=100,
	option=true
})

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
	if url and TARDIS:GetSetting("music-enabled") and TARDIS:GetSetting("sound") then
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

ENT:AddHook("Think", "music", function(self)
	if IsValid(self.music) then
		self.music:SetVolume(TARDIS:GetSetting("music-volume")/100)
		if not (TARDIS:GetSetting("music-enabled") and TARDIS:GetSetting("sound")) then
			self:StopMusic()
		end
	end
end)

ENT:AddHook("OnRemove", "music", function(self)
	self:StopMusic()
end)