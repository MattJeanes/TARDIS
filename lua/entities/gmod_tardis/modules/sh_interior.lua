// Adds an interior

if SERVER then
	local function FindPosition(self,e,double)
		local tracedata = {}
		tracedata.start=(double or self:GetPos())
		tracedata.endpos=tracedata.start+(self:GetUp()*(double and -6000 or 9999999))
		tracedata.mins=e:OBBMins()
		tracedata.maxs=e:OBBMaxs()
		tracedata.filter={self,e}
		tracedata.mask = MASK_NPCWORLDSTATIC
		local traceres=util.TraceHull(tracedata)
		if double then
			return traceres.HitPos
		//elseif tobool(GetConVarNumber("tardis_doubletrace")) // TODO: Use this
		else
			return FindPosition(self,e,traceres.HitPos)
		end
	end

	ENT:AddHook("Initialize", "interior", function(self)
		local e=ents.Create("gmod_tardis_interior")
		e.exterior=self
		e:Spawn()
		e:Activate()
		e:SetPos(FindPosition(self,e))
		self.interior=e
	end)
	
	ENT:AddHook("OnRemove", "interior", function(self)
		if self.interior and IsValid(self.interior) then
			self.interior:Remove()
		end
	end)
end