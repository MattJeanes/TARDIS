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
		if self.music:GetState() == GMOD_CHANNEL_PLAYING then
			TARDIS:Message(LocalPlayer(), "Music stopped")
		end
		self.music:Stop()
		self.music = nil
		self:SendMessage("stop-music", function() end) 
	end
end

local patterns={
	"youtu.be/([_A-Za-z0-9-]+)",
	"youtube.com/watch%?v=([_A-Za-z0-9-]+)",
}
local api="https://youtubedl.mattjeanes.com/"
function ENT:ResolveMusicURL(url)
	if url:find("youtu.be") or url:find("youtube.com") then
		local id=string.match(url,patterns[1]) or string.match(url,patterns[2])
		if id then
			http.Fetch(api.."get?id="..id,
				function(body,len,headers,code)
					local tbl=util.JSONToTable(body)
					if tbl then
						if tbl.success then
							TARDIS:Message(LocalPlayer(), "Playing: " ..tbl.title)
							self:PlayMusic(api.."play?id="..id,true)
						else
							TARDIS:ErrorMessage(LocalPlayer(), "ERROR: Failed to load ("..(tbl.err and tbl.err or "Unknown reason")..")")
						end
					else
						TARDIS:ErrorMessage(LocalPlayer(), "ERROR: Failed to load API response")
					end
				end,
				function(err)
					TARDIS:ErrorMessage(LocalPlayer(), "ERROR: Failed to resolve url ("..err..")")
				end
			)
		else
			TARDIS:ErrorMessage(LocalPlayer(), "ERROR: Couldn't find video ID inside url")
		end
	else
		return url
	end
end

function ENT:PlayMusic(url,resolved)
	if not resolved then
		TARDIS:Message(LocalPlayer(), "Loading music...")
		url=self:ResolveMusicURL(url)
	end
	if url and TARDIS:GetSetting("music-enabled") and TARDIS:GetSetting("sound") then
		self:StopMusic()
		--[[sound.PlayURL(url, "", function(station,errorid,errorname)
			if station then
				station:SetVolume(1)
				station:Play()
				self.music=station
			else
				TARDIS:ErrorMessage(LocalPlayer(), "ERROR: Failed to load song (Error ID: "..errorid..", "..errorname..")")
			end
		end)--]]
		self:SendMessage("play-music", function() 
			net.WriteString(url)
		end)
	end
end

ENT:OnMessage("play-music", function(self)
	local url = net.ReadString()
	
	sound.PlayURL(url, "", function(station,errorid,errorname)
		if station then
			station:SetVolume(1)
			station:Play()
			self.music=station
		else
			TARDIS:ErrorMessage(LocalPlayer(), "ERROR: Failed to load song (Error ID: "..errorid..", "..errorname..")")
		end
	end)
end)

ENT:OnMessage("stop-music", function(self)
	if self.music then
		self.music:Stop()
		self.music=nil
	end
end)

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

ENT:AddHook("PlayerExit", "stop-music-on-exit", function(self)
	if self.music then
		self:StopMusic()
	end
end)

ENT:AddHook("PlayerEnter", "start-music", function(self)
	if self.music then
		self.music:SetVolume(TARDIS:GetSetting("music-volume")/100)
	end
end)