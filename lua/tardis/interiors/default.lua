local T = {}

T.Base = "base"
T.Name = "Interiors.Default"
T.ID = "default"

T.Interior = {

    Model="models/molda/toyota_int/interior.mdl",
    ExitDistance=1450,
    LightOverride = {
        basebrightness = 0.05,
        nopowerbrightness = 0.001,
    },
    Light={
        color=Color(0,255,255),
        pos=Vector(0,0,110),
        brightness=0.5,
        warn_color=Color(0,51,51),
        nopower = true,
        off_color = Color(0,65,215),
        off_brightness = 0.2,
    },
    Lights={
        console_white = {
            pos=Vector(0,0,187),
            brightness=0.3,
            color=Color(100,180,190),
            warncolor=Color(255,143,143),
        },
        lower_light = {
            color=Color(0,50,255),
            warncolor=Color(51,102,102),
            pos=Vector(0,0,-30),
            brightness=1,
        },
    },

    Portal={
        --pos=Vector(-314,0,139.8),
        pos = Vector(-322.5, 0, 139.8),
        ang=Angle(0,0,0),
        width=50,
        height=92,
        --thickness = -5.5,
    },

    Fallback={
        pos=Vector(-280,0,100),
        ang=Angle(0,0,0)
    },
    Parts = {
        door = {
            model="models/vtalanov98/toyota_ext/doors_interior.mdl",
            posoffset=Vector(0.8,0,-52.8),
            angoffset=Angle(0,180,0),
        },
        default_doorframe = {},
        default_doorframe_light = {},
        default_floor = {},
        default_entry = {},
        default_walls = {},
        default_roof = {},
        default_setroof = {},
        default_pillars = {},
        default_rings = {},
        --default_console = { ang = Angle(0,90,0), },
    },
    Controls = {

    },
    TipSettings = {},
    CustomTips = {},
    PartTips = {},
}

T.Exterior = {}

T.Templates = {
    default_exterior = { override = true, },
}


TARDIS:AddInterior(T)
