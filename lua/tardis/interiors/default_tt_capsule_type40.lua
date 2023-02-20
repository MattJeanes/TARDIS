-- Default (TT Mk1 Capsule)

local T = {}
T.Base = "default"
T.Name = "Interiors.DefaultTTCapsuleType40"
T.ID = "default_tt_type40"

T.IsVersionOf = "default"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -36.5),
        ang = Angle(0, 230, 0),
        width = 55,
        height = 95
    },
    Parts = {
        default_doorframe = {
            pos = Vector(317, 336.3, -80.4),
            ang = Angle(0, -40, 0),
            scale = 0.764,
            matrixScale = Vector(1, 1, 1.118)
        },
        default_doorframe_bottom = {
            matrixScale = Vector(0.53, 1.02, 1)
        },
        default_doorframe_bottom2 = {
            matrixScale = Vector(0.54, 1.02, 1)
        },
    },
}

T.Templates = {
    exterior_ttcapsule_type40 = { override = true, fail = function() ErrorNoHalt("Failed to add ttcapsule_type40 default exterior") end, },
}

TARDIS:AddInterior(T)


