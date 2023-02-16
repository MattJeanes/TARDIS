T = {
    Exterior = {
        Model="models/artixc/exteriors/mk3.mdl",
        Mass=5000,
        Portal={
            pos=Vector(19.5,0,52.25),
            ang=Angle(0,0,0),
            width=32,
            height=87,
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
                model="models/artixc/exteriors/mk3_door.mdl",
                posoffset=Vector(-6.5,12.5,-43.2),
                angoffset=Angle(0,0,0),
            },
        }
    },
    Interior = {
        Parts={
            door={
                model="models/artixc/exteriors/mk3_door.mdl",
                posoffset=Vector(6.5,-12.5,-43.2),
            },
        }
    },
}

TARDIS:AddInteriorTemplate("ttcapsule", T)