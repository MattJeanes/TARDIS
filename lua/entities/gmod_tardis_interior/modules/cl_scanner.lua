-- Scanner

ENT:AddHook("ShouldDraw", "scanner", function(self)
	if self.scannerrender then
		return false
	end
end)