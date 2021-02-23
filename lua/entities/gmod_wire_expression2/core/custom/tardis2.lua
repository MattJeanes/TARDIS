E2Lib.RegisterExtension("tardis2", true)

local function getTardis(ent)
	if not IsValid(ent) then return end
	local class = ent:GetClass()
	if class == "gmod_tardis" or class == "sent_tardis" then
		return ent
	elseif class == "sent_tardis_interior" and IsValid(ent.tardis) then
		return ent.tardis
	elseif (class == "gmod_tardis_interior" or ent.Base == "gmod_tardis_part") and IsValid(ent.exterior) then
		return ent.exterior
	elseif ent:IsPlayer() and IsValid(ent.tardis) then
		return ent.tardis.exterior or ent.tardis
	else
		return NULL
	end
end

e2function entity entity:tardisGet()
	return getTardis(this)
end

e2function string entity:t2GetData(string id)
	return tostring(this:GetData(id,false))
end

e2function number entity:tardisDemat(vector pos, angle rot)
	return this:HandleE2("Demat",self, this, pos, rot)
end

e2function number entity:tardisDemat(vector pos)
	return this:HandleE2("Demat",self, this, pos)
end

e2function number entity:tardisMaterialise()
	return this:HandleE2("Mat", self, this)
end

e2function number entity:t2SetDestination(vector pos, angle ang)
	local pos2 = Vector(pos[1], pos[2], pos[3])
	local ang2 = Angle(ang[1], ang[2], ang[3])
	return this:SetDestination(pos2, ang2)
end

e2function number entity:t2SetDestination(vector pos)
	local pos2 = Vector(pos[1], pos[2], pos[3])
	return this:SetDestination(pos2)
end

e2function number entity:t2SetFlight(normal on)
	return this:SetFlight(tobool(on))
end

e2function number entity:t2ToggleFlight()
	return this:ToggleFlight()
end