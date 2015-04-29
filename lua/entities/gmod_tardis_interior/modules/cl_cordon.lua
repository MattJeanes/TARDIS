-- Cordon

hook.Add("wp-prerender", "tardisi-cordon", function(portal,exit,origin)
	local parent=exit:GetParent()
	if parent.TardisInterior then
		for k,v in pairs(parent.props) do
			if IsValid(k) then
				k.olddraw=k:GetNoDraw()
				k:SetNoDraw(false)
			end
		end
	end
end)

hook.Add("wp-postrender", "tardisi-cordon", function(portal,exit,origin)
	local parent=exit:GetParent()
	if parent.TardisInterior then
		for k,v in pairs(parent.props) do
			if IsValid(k) then
				k:SetNoDraw(k.olddraw)
				k.olddraw=nil
			end
		end
	end
end)

ENT:AddHook("Initialize", "cordon", function(self)
	self.props={}
	self.propscan=0
end)

ENT:AddHook("Think", "cordon", function(self)
	if CurTime()>self.propscan then
		self.propscan=CurTime()+1
		local mins,maxs=self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs())
		local intardis=LocalPlayer():GetTardisData("interior")==self
		for k,v in pairs(ents.FindInBox(mins,maxs)) do
			--if not v.TardisPart and not v:GetParent().TardisInterior then
				self.props[v]=true
				if not intardis and v:GetNoDraw() then
					v:SetNoDraw(true)
				end
			--end
		end
		for k,v in pairs(self.props) do
			if not IsValid(k) then
				self.props[k]=nil
			end
		end
	end
end)

ENT:AddHook("PlayerEnter", "cordon", function(self)
	for k,v in pairs(self.props) do
		if IsValid(k) then
			k:SetNoDraw(false)
		end
	end
end)

ENT:AddHook("PlayerExit", "cordon", function(self)
	for k,v in pairs(self.props) do
		if IsValid(k) then
			k:SetNoDraw(true)
		end
	end
end)