T = {
    Exterior = {
        Model="models/vtalanov98/hellbentext/exterior.mdl",
        Mass=5000,
        Portal={
            pos=Vector(16.76,0,52.22),
            ang=Angle(0,0,0),
            width=30,
            height=88,
            thickness = 25,
            inverted = true,
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
    },
    Interior = {
        Parts={
            door={
                model="models/vtalanov98/hellbentext/doors.mdl",
                posoffset=Vector(3, 0, 0),
                use_exit_point_offset = true,
            },
        }
    },
}

TARDIS:AddInteriorTemplate("ttcapsule", T)

local E = TARDIS:CopyTable(T.Exterior)
E.ID = "ttcapsule_type55b"
E.Base = "base"
E.Name = "TT-capsule type 55B"

TARDIS:AddExterior(E)