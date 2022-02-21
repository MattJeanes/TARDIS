-- High Quality Model Prompt 

ENT:AddHook("PlayerEnter", "lod_prompt", function(self)
    if self.metadata.Interior.RequireHighModelDetail ~= false and GetConVarNumber("r_rootlod")>0 then
            Derma_Query(
            "The TARDIS Interior may require model detail on high, set now?",
            "TARDIS Interior",
            "Yes",
            function()
                RunConsoleCommand("r_rootlod", 0)
            end,
            "No",
            nil
        )
    end
end)