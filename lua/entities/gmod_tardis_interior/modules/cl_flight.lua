-- Flight

TARDIS:AddSetting({
	id="flight-internalsound",
	name="Flightmode Internal Sound",
	section="Sounds",
	desc="Whether the flight sound can be heard on the inside or not",
	value=true,
	type="bool",
	option=true
})

ENT:AddHook("OnRemove", "flight", function(self)
	if self.flightsound then
		self.flightsound:Stop()
		self.flightsound=nil
	end
end)

ENT:AddHook("Think", "flight", function(self)
	if self.exterior:GetData("flight") and TARDIS:GetSetting("flight-internalsound") and TARDIS:GetSetting("sound") then
		if self.flightsound and self.flightsound:IsPlaying() then
			local p=math.Clamp(self.exterior:GetVelocity():Length()/250,0,15)
			self.flightsound:ChangePitch(95+p,0.1)
			self.flightsound:ChangeVolume(0.4)
		else
			self.flightsound=CreateSound(self, self.metadata.Interior.Sounds.FlightLoop or self.metadata.Exterior.Sounds.FlightLoop)	
			self.flightsound:Play()
		end
	elseif self.flightsound then
		self.flightsound:Stop()
		self.flightsound=nil
	end
end)