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

function ENT:UpdateCordon()
	local mins,maxs=self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs())
	local intardis=LocalPlayer():GetTardisData("interior")==self
	for k,v in pairs(ents.FindInBox(mins,maxs)) do
		self.props[v]=1
		if not v.tardis_cordon then
			v.tardis_cordon=v:GetNoDraw()
		end
		if v:GetNoDraw()==intardis then
			v:SetNoDraw(not intardis)
		end
	end
	for k,v in pairs(self.props) do
		if IsValid(k) then
			if v==true then -- left
				k:SetNoDraw(k.tardis_cordon)
				k.tardis_cordon=nil
				self.props[k]=nil
			elseif v==1 then
				self.props[k]=true
			end
		else
			self.props[k]=nil
		end
	end
end

ENT:AddHook("Think", "cordon", function(self)
	if CurTime()>self.propscan then
		self.propscan=CurTime()+1
		self:UpdateCordon()
	end
end)

ENT:AddHook("PlayerEnter", "cordon", function(self)
	self:UpdateCordon()
end)

ENT:AddHook("PlayerExit", "cordon", function(self)
	self:UpdateCordon()
end)