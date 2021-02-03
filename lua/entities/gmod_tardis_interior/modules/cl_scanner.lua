-- Scanner

ENT:AddHook("ShouldDraw", "scanner", function(self)
	if self.scannerrender then
		return false
	end
end)

ENT:AddHook("ShouldNotRenderPortal","scanner",function(self,parent,portal)
	if self.scannerrender and portal==self.portals.interior then
		return true
	end
end)

ENT:AddHook("PreScannerRender", "scanner", function(self)
	for k,v in pairs(self.props) do
		if IsValid(k) then
			k.olddraw=k:GetNoDraw()
			k:SetNoDraw(true)
		end
	end
end)

ENT:AddHook("PostScannerRender", "scanner", function(self)
	for k,v in pairs(self.props) do
		if IsValid(k) and k.olddraw~=nil then
			k:SetNoDraw(k.olddraw)
			k.olddraw=nil
		end
	end
end)