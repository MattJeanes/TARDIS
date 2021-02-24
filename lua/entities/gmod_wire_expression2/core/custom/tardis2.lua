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

local function HandleE2(ent, name, ...)
	if IsValid(getTardis(ent)) then
		return ent:HandleE2(name, ...)
	else
		error("Can't call TARDIS functions on something other than a TARDIS.")
	end
end

e2function entity entity:tardisGet()
	return getTardis(this)
end

--Setters and actions

e2function number entity:tardisDemat(vector pos, angle rot)
	return HandleE2(this, "Demat", self, pos, rot)
end

e2function number entity:tardisDemat(vector pos)
	return HandleE2(this, "Demat", self, pos)
end

e2function number entity:tardisMaterialise()
	return HandleE2(this, "Mat", self)
end

e2function number entity:tardisSetDestination(vector pos, angle ang)
	return HandleE2(this, "SetDestination", self, pos, ang)
end

e2function number entity:tardisSetDestination(vector pos)
	return HandleE2(this, "SetDestination", self, pos)
end

e2function number entity:tardisFastReturn()
	return HandleE2(this, "FastReturn", self)
end

e2function number entity:tardisLongflight()
	return HandleE2(this, "Longflight", self)
end

e2function number entity:tardisFlightmode(normal on)
	return HandleE2(this, "Flightmode", self, on)
end

e2function number entity:tardisFlightmode()
	return HandleE2(this, "Flightmode", self)
end

-- Data getters

e2function string entity:tardisGetData(string id)
	return tostring(this:GetData(id,false))
end

e2function number entity:tardisMoving()
	return HandleE2(this, "GetMoving", self)
end

e2function number entity:tardisFlying()
	return HandleE2(this, "GetFlying", self)
end

e2function number entity:tardisHealth()
	return HandleE2(this, "GetHealth", self)
end

e2function number entity:tardisInVortex()
	return HandleE2(this, "GetInVortex", self)
end

e2function number entity:tardisLongflighted()
	return HandleE2(this, "GetLongflight", self)
end

