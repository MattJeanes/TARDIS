-- Cordon

hook.Add("wp-prerender", "tardisi-cordon", function(portal,exit,origin)
	local parent=exit:GetParent()
	if parent.TardisInterior then
		for k,v in pairs(parent.cordon) do
			if IsValid(k) then
				k.olddraw=k:GetNoDraw()
				k:SetNoDraw(false)
				if k:IsPlayer() then
					GAMEMODE:UpdateAnimation(k,k:GetVelocity(),0)
				end
			end
		end
	end
end)

hook.Add("wp-postrender", "tardisi-cordon", function(portal,exit,origin)
	local parent=exit:GetParent()
	if parent.TardisInterior then
		for k,v in pairs(parent.cordon) do
			if IsValid(k) then
				k:SetNoDraw(k.olddraw)
				k.olddraw=nil
			end
		end
	end
end)

--[[
local blendtemp=1
hook.Add("PrePlayerDraw", "tardisi-cordon", function(ply)
	blendtemp=render.GetBlend()
	render.SetBlend(1)
end)

hook.Add("PostPlayerDraw", "tardisi-cordon", function(ply)
	render.SetBlend(blendtemp)
end)
]]--

ENT:AddHook("Initialize", "cordon", function(self)
	self.cordon={}
	self.cordonscan=0
end)

function ENT:UpdateCordon()
	local mins,maxs=self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs())
	local intardis=LocalPlayer():GetTardisData("interior")==self
	for k,v in pairs(ents.FindInBox(mins,maxs)) do
		if IsValid(v) and not v:IsPlayer() and not v:GetParent():IsPlayer() then
			if self.cordon[v]==nil then
				v.tardis_cordon=v:GetNoDraw()
			end
			v:SetNoDraw(not intardis)
			self.cordon[v]=1
		end
	end
	
	for k,v in pairs(self.cordon) do
		if IsValid(k) then
			if v==true then --left
				k:SetNoDraw(k.tardis_cordon)
				k.tardis_cordon=nil
				self.cordon[k]=nil
			elseif v==1 then
				self.cordon[k]=true
			end
		else
			self.cordon[k]=nil
		end
	end
end

ENT:AddHook("Think", "cordon", function(self)
	if CurTime()>self.cordonscan then
		self.cordonscan=CurTime()+1
		self:UpdateCordon()
	end
end)

ENT:AddHook("PlayerEnter", "cordon", function(self,ply)
	if ply==LocalPlayer() then self:UpdateCordon() end
end)

ENT:AddHook("PlayerExit", "cordon", function(self,ply)
	if ply==LocalPlayer() then self:UpdateCordon() end
end)