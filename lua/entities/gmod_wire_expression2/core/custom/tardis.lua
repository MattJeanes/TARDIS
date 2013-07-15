/******************************************************************************\
	Abyss custom E2 functions by Dr. Matt
\******************************************************************************/

E2Lib.RegisterExtension("tardis", true)

local function TARDIS_Teleport(ent,pos,ang)
	if ent and IsValid(ent) and not ent.moving and pos then
		local pos=Vector(pos[1], pos[2], pos[3])
		if ang then ang=Angle(ang[1], ang[2], ang[3]) end
		ent:Go(pos,ang)
		return 1
	else
		return 0
	end
end

local function TARDIS_Phase(ent)
	if ent and IsValid(ent) then
		local success=ent:TogglePhase()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Flightmode(ent)
	if ent and IsValid(ent) then
		local success=ent:ToggleFlight()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Moving(ent)
	if ent and IsValid(ent) then
		if ent.moving then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Visible(ent)
	if ent and IsValid(ent) then
		if ent.visible then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Flying(ent)
	if ent and IsValid(ent) then
		if ent.flightmode then
			return 1
		else
			return 0
		end
	end
	return 0
end

--------------------------------------------------------------------------------
e2function number entity:tardisDemat(vector pos)
	return TARDIS_Teleport(this, pos)
end
e2function number entity:tardisDemat(vector pos, angle rot)
	return TARDIS_Teleport(this, pos, rot)
end

e2function number entity:tardisPhase()
	return TARDIS_Phase(this)
end

e2function number entity:tardisFlightmode()
	return TARDIS_Flightmode(this)
end

e2function number entity:tardisMoving()
	return TARDIS_Moving(this)
end

e2function number entity:tardisVisible()
	return TARDIS_Visible(this)
end

e2function number entity:tardisFlying()
	return TARDIS_Flying(this)
end