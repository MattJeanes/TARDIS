E2Lib.RegisterExtension("tardis", true)

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
        error("Can't call TARDIS functions on something other than a TARDIS.",0)
    end
end

e2function entity entity:tardisGet()
    return getTardis(this)
end

--[[
    ╔═══════════════════╗
    ║Setters and actions║
    ╚═══════════════════╝
]]

--Teleport

e2function number entity:tardisDemat(vector pos, angle rot)
    return HandleE2(this, "Demat", self, pos, rot)
end

e2function number entity:tardisDemat(vector pos)
    return HandleE2(this, "Demat", self, pos)
end

e2function number entity:tardisFastDemat()
    return HandleE2(this, "FastDemat", self)
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

e2function number entity:tardisHADS()
    return HandleE2(this, "HADS", self)
end

--Flight

e2function number entity:tardisFlightmode(normal on)
    return HandleE2(this, "Flightmode", self, on)
end

e2function number entity:tardisFlightmode()
    return HandleE2(this, "Flightmode", self)
end

e2function number entity:tardisPhyslock()
    return HandleE2(this, "Physlock", self)
end

e2function number entity:tardisSpinmode(number spinmode)
    return HandleE2(this, "Spinmode", self, spinmode)
end

e2function number entity:tardisTrack(entity ent)
    return HandleE2(this, "Track", self, ent)
end

--Security

e2function number entity:tardisLock()
    return HandleE2(this, "Lock", self)
end

e2function number entity:tardisIsomorph()
    return HandleE2(this, "Isomorph", self)
end

e2function number entity:tardisPhase()
    return HandleE2(this, "Phase", self)
end

--Extra

e2function number entity:tardisPower()
    return HandleE2(this, "Power", self)
end

e2function number entity:tardisSelfrepair()
    return HandleE2(this, "Selfrepair", self)
end

e2function number entity:tardisPhase()
    return HandleE2(this, "Phase", self)
end

--[[
    ╔════════════╗
    ║Data getters║
    ╚════════════╝
]]

e2function string entity:tardisGetData(string id)
    return tostring(this:GetData(id,false))
end

--Teleport

e2function number entity:tardisMoving()
    return HandleE2(this, "GetMoving", self)
end

e2function number entity:tardisInVortex()
    return HandleE2(this, "GetInVortex", self)
end

e2function number entity:tardisLongflighted()
    return HandleE2(this, "GetLongflight", self)
end

e2function vector entity:tardisLastPos()
    return HandleE2(this, "LastPos", self)
end

e2function angle entity:tardisLastAng()
    return HandleE2(this, "LastAng", self)
end

e2function number entity:tardisIsHADS()
    return HandleE2(this, "GetHADS", self)
end

--Flight

e2function number entity:tardisFlying()
    return HandleE2(this, "GetFlying", self)
end

e2function entity entity:tardisPilot()
    return HandleE2(this, "GetPilot", self)
end

e2function entity entity:tardisTracking()
    return HandleE2(this, "GetTracking", self)
end

e2function number entity:tardisPhyslocked()
    return HandleE2(this, "GetPhyslocked", self)
end

--Health

e2function number entity:tardisHealth()
    return HandleE2(this, "GetHealth", self)
end

e2function number entity:tardisSelfrepairing()
    return HandleE2(this, "GetSelfrepairing", self)
end

--Security

e2function number entity:tardisIsomorphic()
    return HandleE2(this, "GetIsomorphic", self)
end

e2function number entity:tardisLocked()
    return HandleE2(this, "GetLocked", self)
end

--Extra

e2function number entity:tardisVisible()
    return HandleE2(this, "GetVisible", self)
end

e2function number entity:tardisPowered()
    return HandleE2(this, "GetPowered", self)
end