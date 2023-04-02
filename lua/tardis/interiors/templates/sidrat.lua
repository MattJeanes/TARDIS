T = {
    Exterior = {
        Model="models/artixc/exteriors/sidrat.mdl",
        Mass=5000,
        Portal={
            pos=Vector(29.75, 0, 46.5),
            ang=Angle(0,0,0),
            width=25,
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
                model="models/artixc/exteriors/sidrat_door.mdl",
                posoffset=Vector(-29.85,0,-46.45),
                angoffset=Angle(0,0,0),
            },
        }
    },
    Interior = {
        Parts={
            door={
                model="models/artixc/exteriors/sidrat_door.mdl",
                posoffset=Vector(29.85,0,-46.45),
            },
        }
    },
}

TARDIS:AddInteriorTemplate("exterior_sidrat", T)

local E = TARDIS:CopyTable(T.Exterior)
E.ID = "sidrat"
E.Base = "base"
E.Name = "SIDRAT"
E.Category = "TT-capsules"

TARDIS:AddExterior(E)