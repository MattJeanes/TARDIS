-- Default (TT Capsule)

local T = {}
T.Base = "legacy"
T.Name = "Interiors.DefaultTTCapsuleType55B"
T.ID = "legacy_tt_type55b"

T.IsVersionOf = "legacy"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -36.5),
        ang = Angle(0, 230, 0),
        width = 31,
        height = 91
    },
    Parts = {
        legacy_doorframe = {
            pos = Vector(317, 336.3, -80),
            ang = Angle(0, -40, 0),
            scale = 0.764,
            matrixScale = Vector(0.58, 1, 1.083)
        },
        legacy_doorframe_bottom = {
            matrixScale = Vector(0.53, 0.6, 1)
        },
        legacy_doorframe_bottom2 = {
            matrixScale = Vector(0.54, 0.6, 1)
        },
    },
}
T.Exterior = {
    Portal = {
        thickness = 30
    }
}

T.Templates = {
    ttcapsule = { override = true, fail = function() ErrorNoHalt("Failed to add ttcapsule_type55b legacy exterior") end, },
}

TARDIS:AddInterior(T)
