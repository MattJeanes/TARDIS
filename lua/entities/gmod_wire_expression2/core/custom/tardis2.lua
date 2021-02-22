E2Lib.RegisterExtension("tardis2", true)

local function getTardis(ent)
	if ent and IsValid(ent) then
		if ent:GetClass()=="gmod_tardis_interior" and IsValid(ent.exterior) then
			return ent.exterior
		elseif ent:GetClass()=="gmod_tardis" then
			return ent
		elseif ent:IsPlayer() then
			if IsValid(TARDIS:GetExteriorEnt(ent)) then
				return TARDIS:GetExteriorEnt(ent)
			else
				return NULL
			end
		elseif ent.Base == "gmod_tardis_part" then
			return ent.exterior
		else
			return NULL
		end
	end
	return NULL
end

e2function entity entity:t2GetTardis()
	return getTardis(this)
end

e2function string entity:t2GetData(string id)
	return tostring(this:GetData(id,false))
end

e2function number entity:t2Demat(vector pos, angle ang)
	local pos2 = Vector(pos[1], pos[2], pos[3])
	local ang2 = Angle(ang[1], ang[2], ang[3])
	return this:Demat(pos2, ang2)
end

e2function number entity:t2Demat(vector pos)
	local pos2 = Vector(pos[1], pos[2], pos[3])
	return this:Demat(pos2)
end

e2function number entity:t2Mat()
	local ret
	this:Mat(function(result) ret = result end)
	return ret
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