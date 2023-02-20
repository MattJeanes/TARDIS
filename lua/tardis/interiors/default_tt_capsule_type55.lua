-- Default (TT Mk3 Capsule)

local T = {}
T.Base = "default"
T.Name = "Interiors.DefaultTTCapsuleType55"
T.ID = "default_tt_type55"

T.IsVersionOf = "default"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -36.5),
        ang = Angle(0, 230, 0),
        width = 31,
        height = 91
    },
    Parts = {
        default_doorframe = {
            pos = Vector(317, 336.3, -80),
            ang = Angle(0, -40, 0),
            scale = 0.764,
            matrixScale = Vector(0.58, 1, 1.083)
        },
        default_doorframe_bottom = {
            matrixScale = Vector(0.53, 0.6, 1)
        },
        default_doorframe_bottom2 = {
            matrixScale = Vector(0.54, 0.6, 1)
        },
    },
}

T.Templates = {
    exterior_ttcapsule_type55 = { override = true, fail = function() ErrorNoHalt("Failed to add ttcapsule_type55 default exterior") end, },
}

TARDIS:AddInterior(T)


