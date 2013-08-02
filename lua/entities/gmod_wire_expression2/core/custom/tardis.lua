/******************************************************************************\
	TARDIS custom E2 functions by Dr. Matt
\******************************************************************************/

E2Lib.RegisterExtension("tardis", true)

local function TARDIS_Get(ent)
	if ent and IsValid(ent) then
		if ent:GetClass()=="sent_tardis_interior" and IsValid(ent.tardis) then
			return ent.tardis
		elseif ent:GetClass()=="sent_tardis" then
			return ent
		else
			return NULL
		end
	end
	return NULL
end

local function TARDIS_Teleport(ent,pos,ang)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if not ent.moving and pos then
			local pos=Vector(pos[1], pos[2], pos[3])
			if ang then ang=Angle(ang[1], ang[2], ang[3]) end
			ent:Go(pos,ang)
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

local function TARDIS_Phase(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
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
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:ToggleFlight()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Lock(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		ent:ToggleLocked()
		return 1
	end
	return 0
end


local function TARDIS_Moving(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
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
		if not (ent:GetClass()=="sent_tardis") then return 0 end
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
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.flightmode then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Health(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.health then
			return math.floor(ent.health)
		else
			return 0
		end
	end
	return 0
end

--------------------------------------------------------------------------------
e2function entity entity:tardisGet()
	return TARDIS_Get(this)
end

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

e2function number entity:tardisLock()
	return TARDIS_Lock(this)
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

e2function number entity:tardisHealth()
	return TARDIS_Health(this)
end