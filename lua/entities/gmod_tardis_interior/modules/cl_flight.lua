-- Flight

ENT:AddHook("OnRemove", "flight", function(self)
    if self.flightsound then
        self.flightsound:Stop()
        self.flightsound=nil
    end
end)

local function ChooseFlightSound(ent)
    if ent.exterior:GetData("health-warning", false) then
        local current_sound = ent.metadata.Interior.Sounds.FlightLoopDamaged or
            ent.metadata.Exterior.Sounds.FlightLoopDamaged
        ent.flightsound = CreateSound(ent, current_sound)
        ent.flightsounddamaged = true
    else
        local current_sound = ent.metadata.Interior.Sounds.FlightLoop or
            ent.metadata.Exterior.Sounds.FlightLoop
        ent.flightsound = CreateSound(ent, current_sound)
        ent.flightsounddamaged = false
    end
end

ENT:AddHook("Think", "flight", function(self)
    if self.exterior:GetData("flight") and TARDIS:GetSetting("flight-internalsound")
        and TARDIS:GetSetting("sound")
    then
        if self.flightsound and self.flightsound:IsPlaying() then
            local p=math.Clamp(self.exterior:GetVelocity():Length()/250,0,15)
            self.flightsound:ChangePitch(95+p,0.1)
            self.flightsound:ChangeVolume(0.4)

            if self.flightsounddamaged ~= self.exterior:GetData("health-warning",false)
            then
                self.flightsound:Stop()
                ChooseFlightSound(self)
                self.flightsound:Play()
            end
        else
            ChooseFlightSound(self)
            self.flightsound:Play()
        end
    elseif self.flightsound then
        self.flightsound:Stop()
        self.flightsound=nil
    end
end)
