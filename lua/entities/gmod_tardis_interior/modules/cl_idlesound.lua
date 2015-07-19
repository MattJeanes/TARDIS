-- Idle sound

TARDIS:AddSetting({
	id="idlesounds",
	name="Idle Sounds",
	desc="Whether the idle sounds can be heard on the inside or not",
	value=true,
	type="bool",
	option=true
})

ENT:AddHook("Initialize", "idlesound", function(self)
	if self.interior.IdleSound then
		self.idlesounds={}
	end
end)

ENT:AddHook("OnRemove", "idlesound", function(self)
	if self.idlesounds then
		for k,v in pairs(self.idlesounds) do
			v:Stop()
			v=nil
		end
	end
end)

ENT:AddHook("Think", "idlesound", function(self)
	if self.interior.IdleSound and self.idlesounds then
		for k,v in pairs(self.interior.IdleSound) do
			if TARDIS:GetSetting("idlesounds") then -- TODO: add setting here
				if not self.idlesounds[k] then
					self.idlesounds[k]=CreateSound(self, v.path)	
					self.idlesounds[k]:Play()
					self.idlesounds[k]:ChangeVolume(v.volume or 1,0)
				end
			else
				if self.idlesounds[k] then
					self.idlesounds[k]:Stop()
					self.idlesounds[k]=nil
				end
			end
		end
	end
end)