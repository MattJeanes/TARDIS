T = {
    Exterior = {
        Model="models/artixc/exteriors/mk2.mdl",
        Mass=5000,
        Portal={
            pos=Vector(28, 0, 57.1),
            ang=Angle(0,0,0),
            width=40,
            height=96,
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
                model="models/artixc/exteriors/mk2_door.mdl",
                posoffset=Vector(-27.95,0,-56.2),
                angoffset=Angle(0,0,0),
            },
        }
    },
    Interior = {
        Parts={
            door={
                model="models/artixc/exteriors/mk2_door.mdl",
                posoffset=Vector(27.95,0,-56.2),
            },
        }
    },
}

TARDIS:AddInteriorTemplate("exterior_ttcapsule_type50", T)