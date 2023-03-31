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

local function HandleE2(ent, type, name, e2, ...)
    if IsValid(getTardis(ent)) then
        if type == "Setter" and ent:CheckSecurity(e2.player) == false then
            TARDIS:ErrorMessage(e2.player,"Expression2.Security.UseDenied")
        else
            if type == "Setter" and name == "Phase" then
                local ply = ent:GetCreator()
                --local part = TARDIS:GetPart(ent.interior, "default_blacksticks")
                local part = TARDIS:GetRegisteredPart("hads")
                tardisdebug(part.source)
                TARDIS:UsePart(part)
            end
            return ent:HandleE2(name, e2, ...)
        end
    else
        error(TARDIS:GetPhrase("Expression2.Error"),0)
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
    return HandleE2(this, "Setter", "Demat", self, pos, rot)
end

e2function number entity:tardisDemat(vector pos)
    return HandleE2(this, "Setter", "Demat", self, pos)
end

e2function number entity:tardisFastDemat()
    return HandleE2(this, "Setter", "FastDemat", self)
end

e2function number entity:tardisMaterialise()
    return HandleE2(this, "Setter", "Mat", self)
end

e2function number entity:tardisSetDestination(vector pos, angle ang)
    return HandleE2(this, "Setter", "SetDestination", self, pos, ang)
end

e2function number entity:tardisSetDestination(vector pos)
    return HandleE2(this, "Setter", "SetDestination", self, pos)
end

e2function number entity:tardisFastReturn()
    return HandleE2(this, "Setter", "FastReturn", self)
end

e2function number entity:tardisLongflight()
    return HandleE2(this, "Setter", "Longflight", self)
end

e2function number entity:tardisHADS()
    return HandleE2(this, "Setter", "HADS", self)
end

--Flight

e2function number entity:tardisFlightmode(normal on)
    return HandleE2(this, "Setter", "Flightmode", self, on)
end

e2function number entity:tardisFlightmode()
    return HandleE2(this, "Setter", "Flightmode", self)
end

e2function number entity:tardisPhyslock()
    return HandleE2(this, "Setter", "Physlock", self)
end

e2function number entity:tardisSpinmode(number spinmode)
    return HandleE2(this, "Setter", "Spinmode", self, spinmode)
end

e2function number entity:tardisTrack(entity ent)
    return HandleE2(this, "Setter", "Track", self, ent)
end

--Security

e2function number entity:tardisLock()
    return HandleE2(this, "Setter", "Lock", self)
end

e2function number entity:tardisIsomorph()
    return HandleE2(this, "Setter", "Isomorph", self)
end

e2function number entity:tardisPhase()
    return HandleE2(this, "Setter", "Phase", self)
end

--Extra

e2function number entity:tardisPower()
    return HandleE2(this, "Setter", "Power", self)
end

e2function number entity:tardisSelfrepair()
    return HandleE2(this, "Setter", "Selfrepair", self)
end

e2function number entity:tardisPhase()
    return HandleE2(this, "Setter", "Phase", self)
end

e2function number entity:tardisDoor()
    return HandleE2(this, "Setter", "Door", self)
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
    return HandleE2(this, "Getter", "GetMoving", self)
end

e2function number entity:tardisInVortex()
    return HandleE2(this, "Getter", "GetInVortex", self)
end

e2function number entity:tardisLongflighted()
    return HandleE2(this, "Getter", "GetLongflight", self)
end

e2function vector entity:tardisLastPos()
    return HandleE2(this, "Getter", "LastPos", self)
end

e2function angle entity:tardisLastAng()
    return HandleE2(this, "Getter", "LastAng", self)
end

e2function number entity:tardisIsHADS()
    return HandleE2(this, "Getter", "GetHADS", self)
end

--Flight

e2function number entity:tardisFlying()
    return HandleE2(this, "Getter", "GetFlying", self)
end

e2function entity entity:tardisPilot()
    return HandleE2(this, "Getter", "GetPilot", self)
end

e2function entity entity:tardisTracking()
    return HandleE2(this, "Getter", "GetTracking", self)
end

e2function number entity:tardisPhyslocked()
    return HandleE2(this, "Getter", "GetPhyslocked", self)
end

--Health

e2function number entity:tardisHealth()
    return HandleE2(this, "Getter", "GetHealth", self)
end

e2function number entity:tardisSelfrepairing()
    return HandleE2(this, "Getter", "GetSelfrepairing", self)
end

--Security

e2function number entity:tardisIsomorphic()
    return HandleE2(this, "Getter", "GetIsomorphic", self)
end

e2function number entity:tardisLocked()
    return HandleE2(this, "Getter", "GetLocked", self)
end

--Extra

e2function number entity:tardisVisible()
    return HandleE2(this, "Getter", "GetVisible", self)
end

e2function number entity:tardisPowered()
    return HandleE2(this, "Getter", "GetPowered", self)
end

e2function number entity:tardisDoorOpen()
    return HandleE2(this, "Getter", "GetDoor", self)
end