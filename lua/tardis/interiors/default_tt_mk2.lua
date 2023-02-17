-- Default (TT Capsule)

local T = {}
T.Base = "default"
T.Name = "Interiors.DefaultTTMk2"
T.ID = "default_tt_mk2"

T.IsVersionOf = "default"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -31.9),
        ang = Angle(0, 230, 0),
        width = 40,
        height = 96
    },
    Parts = {
        default_doorframe = {
            pos = Vector(317, 336.3, -80.4),
            ang = Angle(0, -40, 0),
            scale = 0.764,
            matrixScale = Vector(0.88, 1, 1.19)
        },
        default_doorframe_bottom = {
            matrixScale = Vector(0.88, 0.9, 1)
        },
        default_doorframe_bottom2 = {
            matrixScale = Vector(0.88, 0.9, 1)
        },
    },
}

T.Templates = {
    ttmk2 = { override = true, fail = function() ErrorNoHalt("Failed to add tt_capsule default exterior") end, },
}

TARDIS:AddInterior(T)


