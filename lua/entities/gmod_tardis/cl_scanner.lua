ENT:AddHook("VortexEnabled", "scanner", function(self)
    if self.interior and self.interior.scannerrender then
        return false
    end
end)