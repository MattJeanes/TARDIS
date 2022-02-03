-- Default (TT Capsule)

TARDIS.Presets = TARDIS.Presets or {}

TARDIS.Presets.tt_capsule_exterior = {
    Model="models/vtalanov98/hellbentext/exterior.mdl",
    Mass=5000,
    Portal={
        pos=Vector(16.76,0,52.22),
        ang=Angle(0,0,0),
        width=30,
        height=88
    },
    Fallback={
        pos=Vector(44,0,7),
        ang=Angle(0,0,0)
    },
    Light={
        enabled=false,
    },
    Sounds={
        Teleport={
            demat="vtalanov98/hellbentext/demat.wav",
            mat="vtalanov98/hellbentext/mat.wav"
        },
        Lock="vtalanov98/hellbentext/lock.wav",
        Door={
            enabled=true,
            open="vtalanov98/hellbentext/doorext_open.wav",
            close="vtalanov98/hellbentext/doorext_close.wav",
        },
        FlightLoop="vtalanov98/hellbentext/flight_loop.wav",
    },
    Parts={
        door={
            model="models/vtalanov98/hellbentext/doorsext.mdl",
            posoffset=Vector(-3,0,0),
            angoffset=Angle(0,0,0)
        },
    }
}




local T = {}
T.Base = "default"
T.Name = "TT Capsule Default"
T.ID = "default-tt-capsule"

T.Interior = {
    Portal = {
        pos = Vector(316.7, 334.9, -36.5),
        ang = Angle(0, 230, 0),
        width = 31,
        height = 87
    },
    Parts = {
        door = {
            model="models/vtalanov98/hellbentext/doors.mdl",
            posoffset=Vector(0,0,0),
            angoffset=Angle(0,180,0),
            --matrixScale = Vector(1.0, 1.7, 1.0),

--            pos = Vector(300, 315, -88.1),
--            ang = Angle(0, 50, 0),
--            width = 443,
--            height = 335
        },
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
T.Exterior = TARDIS.Presets.tt_capsule_exterior

TARDIS:AddInterior(T)
