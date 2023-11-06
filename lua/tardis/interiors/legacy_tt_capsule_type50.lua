-- Default (TT  Mk2 Capsule)

local T = {}
T.Base = "legacy"
T.Name = "Interiors.DefaultTTCapsuleType50"
T.ID = "legacy_tt_type50"

T.IsVersionOf = "legacy"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -31.9),
        ang = Angle(0, 230, 0),
        width = 40,
        height = 99
    },
    Parts = {
        legacy_doorframe = {
            pos = Vector(317, 336.3, -80.4),
            ang = Angle(0, -40, 0),
            scale = 0.764,
            matrixScale = Vector(0.88, 1, 1.19)
        },
        legacy_doorframe_bottom = {
            matrixScale = Vector(0.88, 0.9, 1)
        },
        legacy_doorframe_bottom2 = {
            matrixScale = Vector(0.88, 0.9, 1)
        },
    },
}

T.Templates = {
    exterior_ttcapsule_type50 = { override = true, fail = function() ErrorNoHalt("Failed to add ttcapsule_type50 legacy exterior") end, },
}

TARDIS:AddInterior(T)
