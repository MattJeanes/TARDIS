ENT:AddHook("VortexEnabled", "scanner", function(self)
    if self.interior.scannerrender then
        return false
    end
end)