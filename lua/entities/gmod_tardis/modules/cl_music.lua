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
                            TARDIS:Message(LocalPlayer(), "ERROR: Failed to load ("..(tbl.err and tbl.err or "Unknown reason")..")")
						end
					else
                        TARDIS:Message(LocalPlayer(), "ERROR: Failed to load API response")
					end
				end,
				function(err)
                    TARDIS:Message(LocalPlayer(), "ERROR: Failed to resolve url ("..err..")")
				end
			)
		else
            TARDIS:Message(LocalPlayer(), "ERROR: Couldn't find video ID inside url")
		end
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
                TARDIS:Message(LocalPlayer(), "ERROR: Failed to load song (Error ID: "..errorid..", "..errorname..")")
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