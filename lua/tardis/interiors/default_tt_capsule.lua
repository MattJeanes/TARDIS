-- Default (TT Capsule)

local T = {}
T.Base = "default"
T.Name = "Interiors.DefaultTTCapsule"
T.ID = "default_tt_capsule"

T.IsVersionOf = "default"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -36.5),
        ang = Angle(0, 230, 0),
        width = 31,
        height = 87
    },
    Sounds = {
        Teleport = {
            demat = "drmatt/tardis/demat.wav",
            mat = "drmatt/tardis/mat.wav",
            mat_fail = "drmatt/tardis/mat_fail.wav",
            mat_fast = "p00gie/tardis/mat_fast.wav",
            mat_damaged_fast = "p00gie/tardis/mat_damaged_fast.wav",
            fullflight = "drmatt/tardis/full.wav",
        },
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
    ttcapsule = { override = true, fail = function() ErrorNoHalt("Failed to add tt_capsule default exterior") end, },
}

TARDIS:AddInterior(T)


