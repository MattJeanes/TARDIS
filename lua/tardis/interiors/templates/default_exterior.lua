local E = {
    ID = "default",
    Name = "Exteriors.DefaultPoliceBox",
    Base = "base",
    Category = "Exteriors.Categories.PoliceBoxes",

    Model="models/vtalanov98/toyota_ext/exterior.mdl",
    Mass=2900,

    Parts = {
        door = {
            model="models/vtalanov98/toyota_ext/doors_exterior.mdl",
            posoffset=Vector(-1,0,-52.8),
            angoffset=Angle(0,0,0),
        }
    },
    Portal = {
        pos = Vector(27.8,0,52.33),
        ang = Angle(0,0,0),
        width = 50,
        height = 92,
        thickness = 42,
        inverted = true,
    },
    Light={
        enabled=true,
        pos=Vector(0,0,122),
        color=Color(255,228,91)
    },
}

TARDIS:AddExterior(E)

TARDIS:AddInteriorTemplate("default_exterior", { Exterior = E, })