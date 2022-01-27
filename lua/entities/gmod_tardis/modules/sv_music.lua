function ENT:PlayMusic(url)
    --PrintTable(self.occupants)
    
    if url then
        for ply, _ in pairs(self.occupants) do
            self:SendMessage("play-music", function() 
                net.WriteString(url)
            end, ply)
        end

        self.music = url

        --print(self.music, "NETWORKED MUSIC!")
    end
end

function ENT:StopMusic()
    if self.music then
        for ply, _ in pairs(self.occupants) do
            self:SendMessage("stop-music", function() end, ply)
        end
        self.music = nil

        --print("STOPPED MUSIC FOR ALL PLAYERS!")
    end
end

ENT:OnMessage("play-music", function(self) 
    self:PlayMusic(net.ReadString())
end)

ENT:OnMessage("stop-music", function(self) 
    --print("STOP MUSIC")
    self:StopMusic()
end)