-- Base (seamless portals)
local T = {}
T.Base = "base"
T.ID = "base_seamless"
T.Hidden = true
T.Interior = {
    Portal = {
        seamless = true,
        pos = Vector(316.7, 334.9, -36.5),
        ang = Angle(0, 230, 0),
        width = 45,
        height = 91
    }
}

T.Exterior = {
    Portal = {
        seamless = true,
        pos = Vector(26,0,51.65),
        ang = Angle(0,0,0),
        width = 44,
        height = 91
    }
}

TARDIS:AddInterior(T)