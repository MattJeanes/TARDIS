include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    self.metadata=TARDIS:GetInterior(net.ReadString(), self)

    self.Model=self.metadata.Interior.Model
    self.Fallback=self.metadata.Interior.Fallback
    self.Portal=self.metadata.Interior.Portal
    self.ExitDistance=self.metadata.Interior.ExitDistance
    if GetConVarNumber("r_rootlod")>0 then
		Derma_Query("The TARDIS Interior requires model detail on high, set now?", "TARDIS Interior", "Yes", function() RunConsoleCommand("r_rootlod", 0) end, "No", function() end)
	end
end)

