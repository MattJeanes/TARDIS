ENT:AddHook("ShouldVortexIgnoreZ", "scanner", function(self)
	if self.interior and self.interior.scannerrender then
		return true
	end
end)