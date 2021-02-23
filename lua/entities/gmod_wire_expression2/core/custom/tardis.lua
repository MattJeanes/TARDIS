/******************************************************************************\
	TARDIS custom E2 functions by Dr. Matt
\******************************************************************************/

E2Lib.RegisterExtension("tardis", true)

local function CheckPP(ply, ent) // Prop Protection
	return hook.Call("PhysgunPickup", GAMEMODE, ply, ent)
end

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

local function TARDIS_Phase(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
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

local function TARDIS_Flightmode(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
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

local function TARDIS_Lock(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:ToggleLocked()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Physlock(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:TogglePhysLock()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Power(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:TogglePower()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Isomorph(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") or not IsValid(data.player) then return 0 end
		local success=ent:IsomorphicToggle(data.player)
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Longflight(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:ToggleLongFlight()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Selfrepair(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:ToggleRepair()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Track(data,ent,trackent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:SetTrackingEnt(trackent)
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Spinmode(data,ent,spinmode)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		ent:SetSpinMode(spinmode)
		return ent.spinmode
	end
	return 0
end

local function TARDIS_FastReturn(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:FastReturn()
		if success then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

local function TARDIS_HADS(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:ToggleHADS()
		if success then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_FastDemat(data,ent)
	if ent and IsValid(ent) and CheckPP(data.player,ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		local success=ent:DematFast()
		if success then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

// get details

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

local function TARDIS_Locked(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.locked then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Physlocked(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.physlocked then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Powered(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.power then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Isomorphic(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.isomorphic then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Longflighted(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.longflight then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Selfrepairing(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.repairing then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_LastPos(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.lastpos then
			return ent.lastpos
		else
			return Vector()
		end
	end
	return Vector()
end

local function TARDIS_LastAng(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.lastang then
			return {ent.lastang.p, ent.lastang.y, ent.lastang.r}
		else
			return {0,0,0}
		end
	end
	return {0,0,0}
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

local function TARDIS_Tracking(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if IsValid(ent.trackingent) then
			return ent.trackingent
		else
			return NULL
		end
	end
	return NULL
end

local function TARDIS_InVortex(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.invortex then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_IsHADS(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return 0 end
		if ent.hads then
			return 1
		else
			return 0
		end
	end
	return 0
end

local function TARDIS_Pilot(ent)
	if ent and IsValid(ent) then
		if not (ent:GetClass()=="sent_tardis") then return NULL end
		if not ent.pilot then return NULL end
		return ent.pilot
	end
	return NULL
end

--------------------------------------------------------------------------------

//set details
e2function entity entity:tardisGet()
	return getTardis(this)
end

e2function number entity:tardisDemat(vector pos, angle rot)
	return HandleE2(this, "Demat",self, pos, rot)
end

e2function number entity:tardisDemat(vector pos)
	return HandleE2(this, "Demat",self, pos)
end

e2function number entity:tardisPhase()
	return TARDIS_Phase(self, this)
end

e2function number entity:tardisFlightmode()
	return TARDIS_Flightmode(self, this)
end

e2function number entity:tardisLock()
	return TARDIS_Lock(self, this)
end

e2function number entity:tardisPhyslock()
	return TARDIS_Physlock(self, this)
end

e2function number entity:tardisPower()
	return TARDIS_Power(self, this)
end

e2function number entity:tardisIsomorph()
	return TARDIS_Isomorph(self,this)
end

e2function number entity:tardisLongflight()
	return TARDIS_Longflight(self, this)
end

e2function number entity:tardisMaterialise()
	return HandleE2(this, "Mat", self)
end

e2function number entity:tardisSelfrepair()
	return TARDIS_Selfrepair(self, this)
end

e2function number entity:tardisTrack(entity ent)
	return TARDIS_Track(self, this, ent)
end

e2function number entity:tardisSpinmode(number spinmode)
	return TARDIS_Spinmode(self, this, spinmode)
end

e2function number entity:tardisSetDestination(vector pos, angle ang)
	return HandleE2(this, "SetDestination", self, pos, ang)
end

e2function number entity:tardisSetDestination(vector pos)
	return HandleE2(this, "SetDestination", self, pos)
end

e2function number entity:tardisFastReturn()
	return TARDIS_FastReturn(self, this)
end

e2function number entity:tardisHADS()
	return TARDIS_HADS(self, this)
end

e2function number entity:tardisFastDemat()
	return TARDIS_FastDemat(self, this)
end

// get details
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

e2function number entity:tardisLocked()
	return TARDIS_Locked(this)
end

e2function number entity:tardisPhyslocked()
	return TARDIS_Physlocked(this)
end

e2function number entity:tardisPowered()
	return TARDIS_Powered(this)
end

e2function number entity:tardisIsomorphic()
	return TARDIS_Isomorphic(this)
end

e2function number entity:tardisLongflighted()
	return TARDIS_Longflighted(this)
end

e2function number entity:tardisSelfrepairing()
	return TARDIS_Selfrepairing(this)
end

e2function vector entity:tardisLastPos()
	return TARDIS_LastPos(this)
end

e2function angle entity:tardisLastAng()
	return TARDIS_LastAng(this)
end

e2function entity entity:tardisTracking()
	return TARDIS_Tracking(this)
end

e2function number entity:tardisInVortex()
	return TARDIS_InVortex(this)
end

e2function number entity:tardisIsHADS()
	return TARDIS_IsHADS(this)
end

e2function entity entity:tardisPilot()
	return TARDIS_Pilot(this)
end