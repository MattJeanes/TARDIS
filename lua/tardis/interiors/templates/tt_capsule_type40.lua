local T = {
    Exterior = {
        Model="models/artixc/exteriors/mk1.mdl",
        Mass=5000,
        Portal={
            pos=Vector(30, 0, 46.73),
            ang=Angle(0,0,0),
            width=40,
            height=92,
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
                model="models/artixc/exteriors/mk1_door.mdl",
                posoffset=Vector(-30.05,0,-46.45),
                angoffset=Angle(0,0,0),
            },
        },
        ScannerOffset = Vector(30,0,50),
    },
    Interior = {
        Parts={
            door={
                model="models/artixc/exteriors/mk1_door.mdl",
                posoffset=Vector(30.05,0,-46.45),
                use_exit_point_offset = true,
            },
        }
    },
}

TARDIS:AddInteriorTemplate("exterior_ttcapsule_type40", T)

local E = TARDIS:CopyTable(T.Exterior)
E.ID = "ttcapsule_type40"
E.Base = "base"
E.Name = "Exteriors.TTCapsuleType40"
E.Category = "Exteriors.Categories.TTCapsules"

TARDIS:AddExterior(E)