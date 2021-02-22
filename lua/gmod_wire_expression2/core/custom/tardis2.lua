E2Lib.RegisterExtension("tardis2", true)

local function getTardis(ent)
	if ent and IsValid(ent) then
		if ent:GetClass()=="gmod_tardis_interior" and IsValid(ent.exterior) then
			return ent.exterior
		elseif ent:GetClass()=="gmod_tardis" then
			return ent
		elseif ent:IsPlayer() then
			if IsValid(ent.tardis) then
				return ent.tardis
			else
				return NULL
			end
		else
			return NULL
		end
	end
	return NULL
end

e2function entity entity:tardis2Get()
	return getTardis(this)
end